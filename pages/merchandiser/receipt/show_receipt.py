from fastapi import APIRouter, Request, HTTPException
from fastapi.responses import JSONResponse
from database.db import Database

router = APIRouter()

@router.get("/show_receipt")
async def show_receipt(request: Request):
    db_details = request.session.get("db-details")
    if not db_details:
        raise HTTPException(status_code=401, detail="Not authorized")

    db = Database(**db_details)
    db.connect()

    try:
        query = """
            SELECT 
                r.id, r.timestamp, r.type, r.credentials_id, r.supplier_id, r.owner_id, r.receipt_id
            FROM 
                receipt r
        """
        rows = db.connection.execute(query).fetchall()

        goods = []
        for row in rows:
            goods.append({
                "id": row["id"],
                "timestamp": str(row["timestamp"]),
                "type": row["type"],
                "credentials": row["credentials_id"],
                "supplier": row["supplier_id"],
                "owner": row["owner_id"],
                "receipt": row["receipt_id"]
            })

        return JSONResponse(content={"success": True, "data": goods})

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        db.disconnect()