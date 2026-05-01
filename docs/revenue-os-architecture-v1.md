# 恒致云护 Platform Revenue OS 设计开发方案（R2.0 起步版）

## 1. 目标与范围
- 目标：基于 PRD V1.0，先落地 R2.0 新签客户标准闭环。
- 研发边界：不重建 ERP/WMS/FSM/支付清算/总账，仅做商业化核心闭环。

## 2. R2.0 域模型与服务拆分

### 2.1 领域服务
1. `catalog-service`：SKU、价格表、税类、上下架。
2. `cpq-service`：报价、报价行、自定义行、打包总价、审批触发。
3. `contract-service`：合同结构化、附件、版本、老合同归档。
4. `subscription-service`：订阅生命周期、权益生成、授信开通。
5. `billing-service`：账单、账单行、差额账单、Credit 处理基础能力。
6. `cash-application-service`：银行流水导入、自动匹配、人工认领、核销。
7. `credit-service`：授信额度、账期、占用释放、逾期冻结。
8. `invoice-service`：开票申请、发票状态、账单关联。
9. `audit-service`：关键操作审计日志。

### 2.2 服务间关键关系
- 报价批准后生成合同草案。
- 合同生效触发订阅生成与权益下发。
- 订阅生成账单计划，账单出账后进入认款核销。
- 核销结果更新应收与授信占用。

## 3. 事件总线与消息主题（R2.0 即预留）
- `quote.approved`
- `contract.activated`
- `subscription.activated`
- `bill.issued`
- `bank.statement.imported`
- `payment.reconciled`
- `credit.limit.updated`
- `invoice.requested`

说明：R2.0 先用同步事务 + outbox 可靠投递；R2.1 引入 BillingEvent 统一计费事件。

## 4. 数据库设计（R2.0）
建议 PostgreSQL，按域分 schema：
- `catalog`: `product_sku`, `price_book`
- `cpq`: `quote`, `quote_line`, `custom_line_item`, `bundle_override`, `approval_record`
- `contract`: `contract`, `contract_attachment`
- `subscription`: `subscription`, `entitlement`
- `billing`: `bill`, `bill_line`
- `cash`: `bank_statement`, `payment_record`, `reconciliation_record`
- `credit`: `credit_limit`
- `invoice`: `invoice_application`
- `audit`: `audit_log`

## 5. 审批规则引擎（R2.0）
规则输入：
- 折扣率、毛利率、账期、是否零元、是否含自定义行项目超阈值、是否赠送硬件。

规则输出：
- 审批链（销售负责人/财务/法务/CEO）
- 风险标签（低毛利、超账期、非标打包）

## 6. API 边界（首批）
- `POST /quotes`
- `POST /quotes/{id}/submit-approval`
- `POST /contracts/from-quote/{quoteId}`
- `POST /contracts/{id}/activate`
- `POST /subscriptions/from-contract/{contractId}`
- `POST /bills/generate`
- `POST /bank-statements/import`
- `POST /reconciliations/auto-match`
- `POST /reconciliations/{id}/confirm`
- `POST /credits/{customerId}/grant`
- `POST /invoices/apply`

## 7. 非功能方案落地
- 幂等：对导入流水、核销确认、账单生成使用 `idempotency_key`。
- 可审计：关键写操作统一写 `audit_log`。
- 性能：报价生成目标 <=5 秒，账单列表查询 <=3 秒。

## 8. R2.0 里程碑（6 Sprint）
1. 基础对象与审计框架。
2. CPQ 与审批。
3. 合同与订阅。
4. 账单与认款。
5. 授信账期。
6. 发票与老合同归档。

## 9. 开发约束
- 历史合同采用新老划断，仅归档最小信息。
- HaaS 仅做计费状态影子，不做仓储与维修流程。
- BillingEvent 在 R2.0 仅定义结构，不强制全接入。
