from fastapi import APIRouter, Request, HTTPException
from fastapi.responses import JSONResponse
from database.db import Database

router = APIRouter()

@router.get("/get_create_group_data")
async def get_create_group_data(request: Request):
    db_details = request.session.get("db-details")
    if not db_details:
        raise HTTPException(status_code=401, detail="Database details not found in session. Please log in again.")

    db = Database(host=db_details["host"], port=db_details["port"], user=db_details["user"],
                  password=db_details["password"], database=db_details["database"])
    db.connect()

    try:
        # Fetch data for groups, units, and vac from the database
        query_group = "SELECT id, name FROM `group` WHERE type != 0;"
        result_group = db.connection.execute(query_group).fetchall()
        group_map = {row["id"]: row["name"] for row in result_group}

        # Return the data as JSON
        return JSONResponse(content={
            "group_id": group_map
        })

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

    finally:
        db.disconnect()


