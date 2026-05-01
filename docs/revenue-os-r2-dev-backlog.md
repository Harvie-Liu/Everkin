# Revenue OS R2.0 研发任务拆解（可直接进 Jira）

## Epic 1：产品目录与价格体系
- 建表：`product_sku`, `price_book`
- 接口：SKU CRUD、上/下架
- 验收：下架 SKU 不影响历史报价与合同

## Epic 2：CPQ 报价与审批
- 建表：`quote`, `quote_line`, `custom_line_item`, `bundle_override`, `approval_record`
- 能力：标准报价、自定义行、打包总价、审批流
- 规则：低毛利/高折扣/超账期/零元报价触发审批

## Epic 3：合同管理与新老划断
- 建表：`contract`, `contract_attachment`
- 能力：报价转合同、结构化字段、附件、版本
- 老合同：只读归档最小字段，续费走新合同

## Epic 4：订阅与权益
- 建表：`subscription`, `entitlement`
- 能力：合同生效创建订阅、Pending/Active/Credit Active 状态
- 限制：欠费分级限制与审批例外

## Epic 5：账单与认款核销
- 建表：`bill`, `bill_line`, `bank_statement`, `payment_record`, `reconciliation_record`
- 能力：账单生成、银行流水导入、自动匹配、手工认领
- 重点：一款多单、多款一单、预收款、部分核销、不明款池

## Epic 6：授信与账期
- 建表：`credit_limit`
- 能力：授信审批、额度占用释放、逾期冻结
- 风险：超额度禁止新增订阅与硬件计费项

## Epic 7：发票与审计
- 建表：`invoice_application`, `audit_log`
- 能力：发票申请、状态追踪、账单关联
- 审计：财务敏感动作留痕

## Epic 8：平台底座
- 统一错误码与审计中间件
- Outbox 事件投递
- 幂等框架（核销确认、导入去重、账单重跑）

## DoD（Definition of Done）
- 单元测试覆盖核心计算和规则判断
- 接口契约测试（含鉴权与错误码）
- 关键流程端到端演示脚本
- 审计日志可查询
