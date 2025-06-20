from fastapi import FastAPI, Request, HTTPException
from fastapi.responses import JSONResponse, RedirectResponse
from fastapi.templating import Jinja2Templates
from fastapi.staticfiles import StaticFiles
from fastapi.exceptions import RequestValidationError
from starlette.exceptions import HTTPException as StarletteHTTPException
from starlette.middleware.sessions import SessionMiddleware
import hashlib

from starlette.responses import FileResponse

from pages.merchandiser.good import create_good, show_good, get_create_good_data
from pages.merchandiser.group import create_group, show_group, get_create_group_data
from pages.merchandiser.organisation import create_organisation, show_organisation, get_create_organisation_data
from pages.merchandiser.receipt import create_receipt, show_receipt, show_item

# Import your custom Database class from your module
from database.db import Database

app = FastAPI()

app.include_router(create_good.router)
app.include_router(get_create_good_data.router)
app.include_router(show_good.router)
app.include_router(create_group.router)
app.include_router(get_create_group_data.router)
app.include_router(show_group.router)
app.include_router(create_organisation.router)
app.include_router(get_create_organisation_data.router)
app.include_router(show_organisation.router)
app.include_router(create_receipt.router)
app.include_router(show_receipt.router)
app.include_router(show_item.router)


# Add session middleware; each client gets its own signed session cookie.
# Use a secure and unpredictable secret key in production.
app.add_middleware(SessionMiddleware, secret_key="YOUR_SECRET_KEY_HERE")

app.mount("/static", StaticFiles(directory="static"), name="static")
templates = Jinja2Templates(directory="pages")

# --- Route Definitions ---
@app.get("/", response_class=RedirectResponse)
async def root():
    return RedirectResponse(url="/auth.html")

@app.get('/favicon.ico', include_in_schema=False)
async def favicon():
    return FileResponse("static/favicon.ico")

@app.get("/auth.html")
async def show_auth_page(request: Request):
    # Public page for authentication.
    return templates.TemplateResponse("auth.html", {"request": request})

@app.get("/setup_db.html")
async def show_setup_db_page(request: Request):
    return templates.TemplateResponse("setup_db.html", {"request": request})

@app.get("/error.html")
async def show_error_page(request: Request):
    return templates.TemplateResponse("error.html", {"request": request})

@app.get("/main.html")
async def show_main_page(request: Request):
    # This page requires the user to be logged in.
    if "user" not in request.session:
        return RedirectResponse(url="/auth.html")
    return templates.TemplateResponse("main.html", {"request": request, "user": request.session["user"]})

@app.get("/settings.html")
async def show_settings_page(request: Request):
    # This page requires the user to be logged in.
    if "user" not in request.session:
        return RedirectResponse(url="/auth.html")
    return templates.TemplateResponse("settings.html", {"request": request, "user": request.session["user"]})

@app.get("/merchandiser.html")
async def show_merchandiser_page(request: Request):
    if "user" not in request.session:
        return RedirectResponse(url="/auth.html")
    return templates.TemplateResponse("merchandiser.html", {"request": request, "user": request.session["user"]})

@app.get("/logout")
async def logout(request: Request):
    # Clear the session to log out the current user.
    request.session.clear()
    return RedirectResponse(url="/auth.html")

# --- Exception Handlers ---

@app.exception_handler(StarletteHTTPException)
async def custom_http_exception_handler(request: Request, exc: StarletteHTTPException):
    if exc.status_code == 404:
        return RedirectResponse(url="/error.html")
    return JSONResponse(status_code=exc.status_code, content={"detail": exc.detail})


@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request: Request, exc: RequestValidationError):
    return JSONResponse(status_code=400, content={"detail": exc.errors()})

# --- Login Endpoint (Session Creation) ---

@app.post("/login")
async def login(request: Request):
    try:
        data = await request.json()
        user_login = data.get("user-login")
        user_password = data.get("user-password")

        # Split the database URL into host and port
        if ":" in data.get("db-url"):
            host, port_str = data.get("db-url").split(":")
            port = int(port_str)
        else:
            host = data.get("db-url")
            port = 3306

        db = Database(host=host, port=port, user=data.get("db-login"),
                      password=data.get("db-password"), database=data.get("db-name"))
        db.connect()

        if not db.is_connected():
            return JSONResponse(status_code=503, content={"success": False, "message": "Database connection failed"})

        # Query the database for credentials.
        query = "SELECT COUNT(*) FROM credentials WHERE name = %s AND hashcode = %s"
        password_hash = hashlib.sha512(user_password.encode("utf-8")).hexdigest()
        result = db.connection.execute(query, (user_login, password_hash)).fetchone()

        db.disconnect()

        if result and result[0] > 0:
            request.session["user"] = user_login
            request.session["db-details"] = {
                "host": host,
                "port": port,
                "user": data.get("db-login"),
                "password": data.get("db-password"),
                "database": data.get("db-name")
            }
            return JSONResponse(content={"success": True, "redirect": "/main.html"})
        else:
            return JSONResponse(status_code=401, content={"success": False, "message": "Invalid credentials"})

    except HTTPException as e:
        raise e
    except Exception as e:
        return JSONResponse(status_code=500, content={"success": False, "message": str(e)})
