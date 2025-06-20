from sqlalchemy import create_engine
from sqlalchemy.exc import SQLAlchemyError
from fastapi import HTTPException

class Database:
    def __init__(self, host: str, port: int, user: str, password: str, database: str):
        self.host = host
        self.port = port
        self.user = user
        self.password = password
        self.database = database
        self.engine = None
        self.connection = None

    def connect(self):
        try:
            self.engine = create_engine(f'mysql+mysqlconnector://{self.user}:{self.password}@{self.host}:{self.port}/{self.database}')
            self.connection = self.engine.connect()
            print("Connected to MySQL database")
        except SQLAlchemyError as e:
            error_message = f"Error: {e}"
            print(error_message)
            raise HTTPException(status_code=500, detail=error_message)
            # Alternatively, you can return a structured response like this:
            # return {"success": False, "message": error_message}

    def disconnect(self):
        if self.connection:
            self.connection.close()
            print("Disconnected from MySQL database")

    def is_connected(self):
        return self.connection is not None and not self.connection.closed

    def check_availability(self):
        try:
            temp_engine = create_engine(f'mysql+mysqlconnector://{self.user}:{self.password}@{self.host}:{self.port}')
            temp_connection = temp_engine.connect()
            print("MySQL server is available")
            temp_connection.close()
            return True
        except SQLAlchemyError as e:
            error_message = f"Error: {e}"
            print(error_message)
            # Raise HTTP exception to send a proper error response
            raise HTTPException(status_code=500, detail=error_message)
            # Alternatively, you can return a structured response:
            # return {"success": False, "message": error_message}
        return False
