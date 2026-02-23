# CODEX: prepkit 项目进度追踪

## 项目概览
- 名称: prepkit
- 类型: R 包（数据归一化与变换）
- 领域: 老年学、数字健康、传感器分析
- 核心算法: M-Score（众数范围归一化）`norm_mode_range()`
- 状态: 按 DEV_LOG 记录已具备 CRAN 提交条件，测试覆盖率 100%

## 仓库结构
- R/: 核心函数（norm_* / trans_* / pp_plot）
- man/: 所有导出函数的 Rd 文档
- tests/: testthat 全覆盖测试
- data/: 内置数据集 sim_gait_data.rda
- data-raw/: 数据集生成脚本
- inst/notes_cn/: 中文笔记（构建中排除）
- docs/: pkgdown 站点产物

## CI 策略 (GitHub Actions)
- 日常: push/PR 仅跑 Linux（ubuntu-latest, R release）
- 重大更新: 手动 workflow_dispatch，`full_matrix=true`

## 版本与发布
- NEWS 最新版本: 0.1.1（提交版本号更新）
- DESCRIPTION 版本: 0.1.1

## 近期里程碑 (摘自 DEV_LOG)
- CRAN 合规修复（DESCRIPTION、.Rbuildignore）
- QA 全流程通过（拼写/示例/R CMD check: 0/0/0）
- pkgdown 站点重建并发布
- 覆盖率锁定 100%

## 待确认
- 定义“重大更新”的判定标准（用于触发全矩阵 CI）

## 后续建议
- 提交到 CRAN
- 继续推进 M-Score 论文写作
- 需要时探索 Python 原型或 C++ 加速
