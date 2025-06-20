from fastapi import APIRouter, Request, HTTPException
from fastapi.responses import JSONResponse
from database.db import Database

router = APIRouter()

@router.get("/show_organisation")
async def show_organisation(request: Request):
    db_details = request.session.get("db-details")
    if not db_details:
        raise HTTPException(status_code=401, detail="Not authorized")

    db = Database(**db_details)
    db.connect()

    try:
        query = """
            SELECT 
                org.name, org.type, org.vat, gr.name as group_name
            FROM 
                `organisation` org
            LEFT JOIN
                `group` gr ON org.group_id = gr.id
            WHERE 
                gr.active = 1
                AND gr.type != 0
        """
        rows = db.connection.execute(query).fetchall()

        group = []
        for row in rows:
            group.append({
                "name": row["name"],
                "type": row["type"],
                "vat": row["vat"],
                "group": row["group_name"]
            })

        return JSONResponse(content={"success": True, "data": group})

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        db.disconnect()
