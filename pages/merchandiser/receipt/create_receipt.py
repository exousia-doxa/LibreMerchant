from fastapi import APIRouter, Request, HTTPException
from fastapi.responses import JSONResponse
from database.db import Database

router = APIRouter()

@router.post("/create_receipt")
async def create_receipt(request: Request):
    db_details = request.session.get("db-details")
    if not db_details:
        raise HTTPException(status_code=401, detail="Database details not found in session. Please log in again.")

    db = Database(host=db_details["host"], port=db_details["port"], user=db_details["user"],
                  password=db_details["password"], database=db_details["database"])
    db.connect()

    try:
        data = await request.json()
        db.connection.execute("SET @status = NULL;")
        query = "CALL create_receipt(%s, %s, %s, %s, %s, %s, @status)"
        db.connection.execute(query, (data.get("timestamp"), data.get("type"), data.get("credentials"),
                                      data.get("supplier"), data.get("owner"), data.get("receipt")))
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