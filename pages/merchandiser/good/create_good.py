from fastapi import APIRouter, Request, HTTPException
from fastapi.responses import JSONResponse
from database.db import Database

router = APIRouter()

# Map stored procedure status codes to error messages
ERROR_MAP = {
    1: "Record not found",
    2: "Duplicate entry - this product already exists",
    3: "Cannot delete - product has related records in other tables",
    4: "Invalid input data",
}


def get_error_message(status_code):
    return ERROR_MAP.get(status_code, f"Database error (code: {status_code})")


@router.post("/create_good")
async def create_good(request: Request):
    db_details = request.session.get("db-details")
    if not db_details:
        return JSONResponse(
            status_code=401,
            content={"success": False, "error": "Database details not found in session"}
        )

    db = Database(**db_details)
    try:
        db.connect()
        data = await request.json()

        # Call stored procedure
        db.connection.execute("SET @status = NULL;")
        query = "CALL create_good(%s, %s, %s, %s, %s, %s, %s, @status)"
        params = (
            data.get("name"),
            data.get("code"),
            data.get("unit"),
            data.get("uktzed") or None,
            data.get("vac"),
            int(data.get("excise", False)),
            data.get("group")
        )

        db.connection.execute(query, params)
        db.connection.execute("COMMIT;")

        # Get procedure result
        result = db.connection.execute("SELECT @status AS status;").fetchone()
        status = result["status"] if result else None

        if status == 0:
            return JSONResponse(content={"success": True})
        else:
            error_msg = get_error_message(status)
            return JSONResponse(
                status_code=400,
                content={"success": False, "error": error_msg}
            )

    except Exception as e:
        return JSONResponse(
            status_code=500,
            content={"success": False, "error": str(e)}
        )
    finally:
        db.disconnect()


@router.post("/update_good")
async def update_good(request: Request):
    db_details = request.session.get("db-details")
    if not db_details:
        return JSONResponse(
            status_code=401,
            content={"success": False, "error": "Database details not found in session"}
        )

    db = Database(**db_details)
    try:
        db.connect()
        data = await request.json()

        # Call stored procedure
        db.connection.execute("SET @status = NULL;")
        query = "CALL update_good(%s, %s, %s, %s, %s, %s, %s, %s, %s, @status)"
        params = (
            data.get("id"),
            data.get("active"),
            data.get("name"),
            data.get("code"),
            data.get("unit"),
            data.get("uktzed") or None,
            data.get("vac"),
            int(data.get("excise", False)),
            data.get("group")
        )

        db.connection.execute(query, params)
        db.connection.execute("COMMIT;")

        # Get procedure result
        result = db.connection.execute("SELECT @status AS status;").fetchone()
        status = result["status"] if result else None

        if status == 0:
            return JSONResponse(content={"success": True})
        else:
            error_msg = get_error_message(status)
            return JSONResponse(
                status_code=400,
                content={"success": False, "error": error_msg}
            )

    except Exception as e:
        return JSONResponse(
            status_code=500,
            content={"success": False, "error": str(e)}
        )
    finally:
        db.disconnect()


@router.delete("/delete_good/{good_id}")
async def delete_good(request: Request, good_id: int):
    db_details = request.session.get("db-details")
    if not db_details:
        return JSONResponse(
            status_code=401,
            content={"success": False, "error": "Database details not found in session"}
        )

    db = Database(**db_details)
    try:
        db.connect()

        # Call stored procedure
        db.connection.execute("SET @status = NULL;")
        query = "CALL delete_good(%s, @status)"
        db.connection.execute(query, (good_id,))
        db.connection.execute("COMMIT;")

        # Get procedure result
        result = db.connection.execute("SELECT @status AS status;").fetchone()
        status = result["status"] if result else None

        if status == 0:
            return JSONResponse(content={"success": True})
        else:
            error_msg = get_error_message(status)
            return JSONResponse(
                status_code=400,
                content={"success": False, "error": error_msg}
            )

    except Exception as e:
        return JSONResponse(
            status_code=500,
            content={"success": False, "error": str(e)}
        )
    finally:
        db.disconnect()