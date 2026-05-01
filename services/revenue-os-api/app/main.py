from fastapi import FastAPI
from pydantic import BaseModel
from typing import List, Optional

app = FastAPI(title="Revenue OS API", version="0.1.0")


class QuoteCreate(BaseModel):
    customer_id: str
    currency: str = "CNY"
    lines: List[dict]
    custom_line_items: Optional[List[dict]] = None
    bundle_total_price: Optional[float] = None


@app.get("/health")
def health():
    return {"status": "ok"}


@app.post("/quotes")
def create_quote(payload: QuoteCreate):
    return {"quote_id": "Q-PLACEHOLDER", "status": "draft", "payload": payload.model_dump()}


@app.post("/quotes/{quote_id}/submit-approval")
def submit_quote_approval(quote_id: str):
    return {"quote_id": quote_id, "approval_status": "pending"}


@app.post("/contracts/from-quote/{quote_id}")
def create_contract_from_quote(quote_id: str):
    return {"contract_id": "C-PLACEHOLDER", "quote_id": quote_id, "status": "draft"}


@app.post("/contracts/{contract_id}/activate")
def activate_contract(contract_id: str):
    return {"contract_id": contract_id, "status": "active"}


@app.post("/subscriptions/from-contract/{contract_id}")
def create_subscription_from_contract(contract_id: str):
    return {"subscription_id": "S-PLACEHOLDER", "contract_id": contract_id, "status": "pending"}
