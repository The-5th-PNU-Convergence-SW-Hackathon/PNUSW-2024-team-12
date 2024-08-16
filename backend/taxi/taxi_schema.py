from pydantic import BaseModel

class TaxiResponse(BaseModel):
    driver_name: str
    car_num: str
    car_model: str

