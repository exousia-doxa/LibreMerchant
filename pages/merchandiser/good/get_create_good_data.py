from fastapi import APIRouter, Request, HTTPException
from fastapi.responses import JSONResponse
from database.db import Database

router = APIRouter()

@router.get("/get_create_good_data")
async def get_create_good_data(request: Request):
    db_details = request.session.get("db-details")
    if not db_details:
        raise HTTPException(status_code=401, detail="Database details not found in session. Please log in again.")

    db = Database(host=db_details["host"], port=db_details["port"], user=db_details["user"],
                  password=db_details["password"], database=db_details["database"])
    db.connect()

    try:
        query_group = "SELECT id, name FROM `group` WHERE type = 3 AND active = 1"
        query_unit = "SELECT id, name FROM `unit`"
        query_vac = "SELECT id, name FROM `vac`"
        result_group = db.connection.execute(query_group).fetchall()
        result_unit = db.connection.execute(query_unit).fetchall()
        result_vac = db.connection.execute(query_vac).fetchall()
        group_map = {row["id"]: row["name"] for row in result_group}
        unit_map = {row["id"]: row["name"] for row in result_unit}
        vac_map = {row["id"]: row["name"] for row in result_vac}

        return JSONResponse(content={
            "group": group_map,
            "unit": unit_map,
            "vac": vac_map
        })

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

    finally:
        db.disconnect()
