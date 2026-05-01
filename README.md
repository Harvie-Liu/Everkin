# Everkin Revenue OS Bootstrap

## 本次新增
- R2.0 开发下一步：后端 API 骨架（FastAPI）
- R2.0 基础库表初始化 SQL（PostgreSQL）

## 运行 API
```bash
cd services/revenue-os-api
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

## 当前接口（骨架）
- `GET /health`
- `POST /quotes`
- `POST /quotes/{quote_id}/submit-approval`
- `POST /contracts/from-quote/{quote_id}`
- `POST /contracts/{contract_id}/activate`
- `POST /subscriptions/from-contract/{contract_id}`

## 下一步
- 接入 PostgreSQL 存储层
- 引入审批规则引擎
- 增加审计中间件与幂等键
