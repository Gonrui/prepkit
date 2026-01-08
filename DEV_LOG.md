# prepr 开发日志 (Development Log)

## Day 3: 自动化与云端部署 (2026-01-05)

**耗时**: 1.5 小时 **状态**: ✅ 完成

### 🚀 核心进展 (Key Progress)

1.  **GitHub Education 申请**
    -   提交了作为 Tokyo Metropolitan University (Visiting Researcher) 的身份证明。
    -   目的：解锁 Copilot Pro 和 GitHub Actions 无限额度。
    -   状态：Pending Review (等待审核)。
2.  **多机工作流确立 (Multi-machine Workflow)**
    -   解决了 Dropbox 同步隐患，迁移至纯 Git 流程。
    -   确立每日口诀：`Pull` (开工前拉取) -\> `Commit` (完工后提交) -\> `Push` (上传云端)。
    -   解决了 `Author identity unknown` (配置 git config) 和 `Everything up-to-date` (忘记 commit) 等新手问题。
3.  **CI/CD 流水线部署**
    -   使用 `usethis::use_github_action("check-standard")` 生成配置。
    -   成功将自动化测试部署到 GitHub Actions。
    -   **结果**: 每次 Push 代码，GitHub 服务器会自动在 Linux/Mac/Windows 上运行 `R CMD check`。

### 🐛 问题修复 (Troubleshooting)

-   **Error**: `curl_modify_url is not an exported object`
    -   **原因**: 本地 `curl` 和 `usethis` 包版本过旧。
    -   **解决**: 重启 RSession 后强制重装 `curl`, `httr2`, `usethis`。

### 🔮 下一步计划 (Next Steps)

-   **Day 4**: 代码覆盖率 (Code Coverage)
    -   引入 `covr` 包。
    -   量化测试用例对代码的覆盖程度，目标 100%。

## Day 4: 覆盖率监控与 Z-Score 算法 (2026-01-06)

**耗时**: 1.5 小时 **状态**: ✅ 完成

### 🚀 核心进展 (Key Progress)

1.  **质量监控体系 (Quality Assurance)**
    -   安装并配置 `covr` 包。
    -   修复了 `tests/testthat` 文件在多机同步中丢失的问题。
    -   **里程碑**: 实现了测试覆盖率 (Code Coverage) 达到 **100%**。
2.  **核心算法实现: Z-Score**
    -   实现了 `norm_zscore` (Standard Score)。
    -   **工程优化**: 特别处理了标准差为 0 (Zero Variance) 的边界情况，防止除以 0 导致的 `Inf/NaN` 错误，改为返回全 0 向量并发出警告。
    -   添加了对应的 `testthat` 测试用例（含边界测试）。
3.  **国际化重构 (Refactoring for I18n)**
    -   将 `R/` 和 `tests/` 目录下所有的代码注释从中文重构为 **英文 (English)**。
    -   目的：符合 CRAN 发布标准，提升开源项目的专业度。
4.  **科研文档 (Documentation)**
    -   创建 `inst/notes_cn/02_norm_zscore.md`。
    -   记录了 Z-Score 的数学原理及其与 Min-Max 的对比分析。

### 🐛 问题修复 (Troubleshooting)

-   **Issue**: `covr::report()` 最初显示 0% 覆盖率。
    -   **原因**: `tests/testthat/test-norm_minmax.R` 文件缺失（未同步）。
    -   **解决**: 使用 `usethis::use_test()` 重建文件并补全测试代码。

### 🔮 下一步计划 (Next Steps)

-   **Day 5**: 进阶算法开发
    -   实现 **Robust Scaler** (鲁棒标准化)，使用 Median 和 MAD 抗衡异常值。
    -   继续保持 100% 测试覆盖率。
## Day 5: 鲁棒算法与线性归一化体系 (2026-01-07)

**耗时**: 2.5 小时 (超额完成)
**状态**: ✅ 里程碑达成 (5/10 算法)

### 🚀 核心进展 (Key Progress)

1.  **算法库大扩容 (Algorithm Expansion)**
    * **Robust Scaler (`norm_robust`)**: 实现基于 Median 和 MAD 的抗干扰标准化。
    * **Decimal Scaling (`norm_decimal`)**: 实现移动小数点的缩放方法。
    * **Mean Normalization (`norm_mean`)**: 实现均值中心化 + 极差缩放。
    * **里程碑**: 目前已集齐 A 类 (线性) 和 B 类 (标准化) 的 5 大核心算法。

2.  **学术规范化 (Academic Rigor)**
    * 全面引入参考文献机制 (`@references`)。
    * 为所有函数添加了经典教材引用：
        * Han, J., et al. (2011) *Data Mining: Concepts and Techniques*.
        * Huber, P. J. (1981) *Robust Statistics*.
    * 提升了包的专业度和 JOSS 论文的可信度。

3.  **质量攻坚 (Quality Assurance)**
    * **覆盖率修复**: 发现并修复了 `norm_robust` 中未被测试覆盖的输入类型检查 (`stopifnot`)，将覆盖率从 95% 提升回 **100%**。
    * **边界防御**: 为所有新算法添加了零方差 (Zero Variance/Range) 的防御逻辑。
    
### 🔧 基础设施升级 (Infrastructure)

* **Rcpp 环境配置**:
    * 修改 `DESCRIPTION` 添加 `Imports: Rcpp` 和 `LinkingTo: Rcpp`。
    * 创建 `src/` 目录和 `.gitignore`。
    * 创建 `R/prepr-package.R` 用于管理命名空间。
    * **状态**: 已配置但处于“休眠”状态 (Commented out `@useDynLib`)，待未来引入 C++ 代码时激活。

### 📝 经验总结 (Learnings)

* **测试盲区**: `covr` 报告中的红色感叹号 (`!`) 非常有用，它帮我发现了虽然测试通过了、但从未触发过的防御性代码（如输入类型检查）。
* **设计模式**: 发现 `norm_minmax`, `norm_mean`, `norm_decimal` 遵循相似的 "Validation -> Statistics -> Edge Case -> Calculation" 结构，这种标准化的代码结构极大地提高了开发效率。

### 🔮 下一步计划 (Next Steps)

* **Day 6**: 非线性变换 (Non-linear Transformations)
    * 挑战 **Box-Cox 变换** (`trans_boxcox`)。
    * 这是包里第一个需要“参数自动优化” (Optimization) 的高级算法，难度会提升一个台阶。
    
## Day 6: 非线性变换、可视化与学术加固 (2026-01-08)

**耗时**: 4 小时
**状态**: ✅ 核心算法库 (100%) + 可视化系统 (100%)

### 🚀 核心进展 (Key Progress)

1.  **非线性变换算法矩阵 (The Non-linear Suite)**
    * **`trans_boxcox`**: 实现了基于 MLE (极大似然估计) 的 $\lambda$ 自动搜索，内建 **Auto-shift** 机制自动处理非正数。
    * **`trans_yeojohnson`**: 实现了 Box-Cox 的进阶版，原生支持负数数据的幂变换。
    * **`trans_log`**: 实现了带 Offset 的对数变换，作为基准非线性处理方案。
    * **`norm_l2`**: 实现了 L2 归一化 (Spatial Sign)，为未来处理高维稀疏数据奠定基础。

2.  **可视化反馈系统 (Visual Feedback)**
    * **`pp_plot`**: 基于 `ggplot2` 构建了对比绘图函数。
    * **功能**: 自动通过分面 (Facet) 展示变换前后的直方图与密度曲线，让用户直观验证“正态化”效果。
    * **解决痛点**: 解决了 `NAMESPACE` 未注册导致找不到 `ggplot` 函数的问题。

3.  **学术加固 (Academic Rigor)**
    * 全面补全了算法的 APA 格式参考文献 (`@references`)。
    * 引用源包括 *J. R. Stat. Soc.* (Box-Cox), *Biometrika* (Yeo-Johnson), *Biometrics* (Bartlett) 及数据挖掘经典教材。
    * **意义**: 确保包符合 JOSS 和 R Journal 的出版标准，体现“有理有据”的科研属性。

### 🧠 架构决策与工程哲学 (Architecture & Philosophy)

* **数据折叠论 (The Art of Folding)**: 确立了对高维数据的核心理解——内存是线性的绳子，Tensor 是折叠的艺术。未来将通过 Rcpp + 稀疏矩阵解决内存瓶颈。
* **混合后端策略 (Hybrid Backend)**: 制定了长期演进路线：
    * **Phase 1 (Current)**: 原生 R 实现，侧重稳定性、可读性和原子化 (Atomic)。
    * **Phase 2 (Future)**: 引入 Rcpp 后端，针对大数据量自动切换引擎。
* **原子化设计**: 坚持 `trans_*` 和 `norm_*` 函数只处理向量。矩阵和数据框的分发逻辑将由上层 Wrapper 处理，保持底层函数的纯粹性。

### 📝 经验总结 (Learnings)

* **Optimization**: R 的 `optimize()` 函数在单参数搜索中表现稳定。
* **Attributes**: 使用 `attr(res, "param")` 携带元数据（如 lambda），既保留了向量的计算特性，又保留了参数信息。
* **Package Namespace**: 深刻理解了 `devtools::document()` 的作用——它不仅生成文档，更是将 `@import` 写入 `NAMESPACE` 的关键步骤。

### 🔮 下一步计划 (Next Steps: Day 7)

**目标**: 文档工程与用户体验 (Documentation & UX)

1.  **README.md 大修**:
    * 这是项目的“门面”。需要添加 Badges (构建状态)、安装指南。
    * **关键**: 展示 `pp_plot` 生成的“Before vs After”对比图，用视觉冲击吸引用户。
2.  **构建 Vignette (长文档)**:
    * 编写一篇 `Getting Started with prepr`。
    * 像讲故事一样，演示从“读取脏数据”到“清洗完成”的全流程。
3.  **高级封装 (Smart Wrapper)** (可选):
    * 尝试编写一个通用的 `prepr_map()` 或 `prepr_process()` 函数，让用户能一行代码处理整个 Data Frame。
