# 02. Z-Score 标准化 (Standard Score)

**日期**: 2026-01-06
**算法**: Z-Score Standardization (Zero-Mean, Unit-Variance)

## 1. 数学定义

Z-Score 标准化（也称为标准差标准化）通过对数据进行中心化（Centering）和缩放（Scaling），使其符合标准正态分布的统计特性（均值为 0，标准差为 1）。

公式如下：

$$
x' = \frac{x - \mu}{\sigma}
$$

其中：
* $x$ 是原始数据向量。
* $\mu$ 是样本均值 (`mean`)。
* $\sigma$ 是样本标准差 (`sd`)。

转换后的数据特性：
* **均值 (Mean)**: 0
* **标准差 (SD)**: 1

---

## 2. 工程实现与边界情况

在 `prepr::norm_zscore` 函数的实现中，我们特别处理了 **方差为 0 (Zero Variance)** 的情况。

### 问题描述
当输入向量的所有值都相同时（例如 `c(5, 5, 5)`），标准差 $\sigma = 0$。根据公式，除以 0 会导致计算结果为 `Inf` (无穷大) 或 `NaN` (非数字)。这在机器学习流水线中是致命错误，会导致后续模型崩溃。

### 解决方案
我们在代码中加入了防御性逻辑：
1.  计算 `sd(x)`。
2.  如果 `sd == 0`（或 `NA`），则**不进行缩放**，仅进行**中心化**。
3.  返回向量 $x - \mu$（即全 0 向量）。
4.  **发出警告 (Warning)**：提示用户数据缺乏变异性。

代码片段：
```r
if (is.na(sd_val) || sd_val == 0) {
  warning("Standard deviation is zero. Returning centered vector (zeros).")
  return(x - mean_val)
}

