from fastapi import APIRouter, Request, HTTPException
from fastapi.responses import JSONResponse
from database.db import Database

router = APIRouter()

@router.get("/show_item")
async def show_item(request: Request, id: int):
    db_details = request.session.get("db-details")
    if not db_details:
        raise HTTPException(status_code=401, detail="Not authorized")

    db = Database(**db_details)
    db.connect()


    try:
        query = """
            SELECT 
                good.name as "good", item.amount, item.cost, item.price, item.excise, item.receipt_id
            FROM 
                item item
            LEFT JOIN
                `goodorg` goodorg ON item.goodorg_id = goodorg.good_id
            LEFT JOIN
                `good` good ON goodorg.good_id = good.id
            WHERE
                item.receipt_id = %s
        """
        rows = db.connection.execute(query, (id,)).fetchall()

        goods = []
        for row in rows:
            goods.append({
                "good": str(row["good"]),
                "amount": str(row["amount"]),
                "cost": str(row["cost"]),
                "price": str(row["price"]),
                "excise": str(row["excise"]),
                "receipt": str(row["receipt_id"])
            })

        return JSONResponse(content={"success": True, "data": goods})

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        db.disconnect()