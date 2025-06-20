from fastapi import APIRouter, Request, HTTPException
from fastapi.responses import JSONResponse
from database.db import Database

router = APIRouter()

@router.get("/show_good")
async def show_good(request: Request):
    db_details = request.session.get("db-details")
    if not db_details:
        return JSONResponse(
            status_code=401,
            content={"success": False, "error": "Not authorized"}
        )

    db = Database(**db_details)
    try:
        db.connect()
        query = """
            SELECT 
                g.active, g.id, g.name, g.code, u.name as 'unit', 
                g.ucgfea as 'uktzed', v.name as 'vat', 
                g.excise, gr.name AS 'group'
            FROM 
                good g
            LEFT JOIN 
                `group` gr ON g.group_id = gr.id
            LEFT JOIN
                `unit` u ON g.unit = u.id
            LEFT JOIN
                `vac` v ON g.vac = v.id
        """
        rows = db.connection.execute(query).fetchall()

        goods = []
        for row in rows:
            goods.append({
                "active": row["active"],
                "id": row["id"],
                "name": row["name"],
                "code": row["code"],
                "unit": row["unit"],
                "uktzed": row["uktzed"],
                "vac": row["vat"],
                "excise": bool(row["excise"]),
                "group": row["group"]
            })

        return JSONResponse(content={"success": True, "data": goods})

    except Exception as e:
        return JSONResponse(
            status_code=500,
            content={"success": False, "error": str(e)}
        )
    finally:
        db.disconnect()