from fastapi import APIRouter, Request, HTTPException
from fastapi.responses import JSONResponse
from database.db import Database

router = APIRouter()

@router.post("/create_group")
async def create_group(request: Request):
    db_details = request.session.get("db-details")
    if not db_details:
        raise HTTPException(status_code=401, detail="Database details not found in session. Please log in again.")

    db = Database(host=db_details["host"], port=db_details["port"], user=db_details["user"],
                  password=db_details["password"], database=db_details["database"])
    db.connect()

    try:
        data = await request.json()
        db.connection.execute("SET @status = NULL;")
        query = "CALL create_group(%s, %s, %s, @status)"  # Adjust the number of placeholders as needed
        db.connection.execute(query, (data.get("name"), data.get("type"), data.get("supergroup")))
        db.connection.execute("COMMIT;")
        result = db.connection.execute("SELECT @status;").fetchone()
        status = result[0] if result else None

        return JSONResponse(content={"success": True})

    except HTTPException as http_exc:
        raise http_exc
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

    finally:
        db.disconnect()