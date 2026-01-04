# 算法笔记 01: 最小-最大归一化 (Min-Max Normalization)

**作者**: Gong Rui  
**日期**: 2026-01-04  
**关联函数**: `prepr::norm_minmax`

---

## 1. 数学原理 (Mathematical Formulation)

Min-Max 归一化（也称为离差标准化）是对原始数据的线性变换。它将数据映射到预定义的范围 $[new\_min, new\_max]$（通常是 $[0, 1]$）。

### 核心公式
$$
x' = \frac{x - \min(x)}{\max(x) - \min(x)} \times (new\_max - new\_min) + new\_min
$$

其中：
* $x$: 原始数值
* $x'$: 归一化后的数值
* $\min(x), \max(x)$: 原始数据的极值

### 几何意义
这种方法本质上是**平移**（由 $\min(x)$ 决定）和**缩放**（由 $\max(x) - \min(x)$ 决定）。它**不会改变**数据的分布形状（Distribution Shape），只是将其压缩或拉伸到了新的刻度轴上。

---

## 2. 适用场景与局限 (Pros & Cons)

### ✅ 适用场景
1.  **有界数据**: 当你需要数据严格限制在某个区间（如图像像素 0-255，或者概率 0-1）时。
2.  **不改变分布**: 当后续算法（如相关性分析）依赖于原始分布形状时。
3.  **距离算法**: 在 KNN 或 K-Means 中，防止大数值特征（如年薪）淹没小数值特征（如年龄）。

### ⚠️ 致命缺陷 (The "Outlier" Problem)
Min-Max 对**异常值 (Outliers)** 极其敏感。
* **例子**: 假设数据是 `[1, 2, 3, 100]`。
* **结果**: `100` 会变成 `1.0`，而 `1, 2, 3` 会被压缩到 `0.0, 0.01, 0.02` 附近。
* **后果**: 正常数据的差异性完全丢失。
* **未来对策**: 这一缺陷将由后续开发的 `Robust Normalization` (基于四分位距 IQR) 来解决。

---

## 3. 代码实现逻辑复盘 (Implementation Detail)

作为开发者，在 `R/norm_minmax.R` 中我做出了以下设计决策：

1.  **效率优化**:
    * 使用 `range(x)` 而不是分别调用 `min(x)` 和 `max(x)`。在 R 语言底层，`range` 只需要遍历一次数据，效率提升一倍。

2.  **防御性编程 (Edge Case)**:
    * **零方差问题**: 当 $\max(x) = \min(x)$ 时，分母为 0。
    * **处理策略**: 我选择了返回 `min_val` (下界)，并抛出 `warning`。这比直接报错中断程序更温和，适合批处理。

3.  **参数校验**:
    * 强制检查 `min_val < max_val`，防止用户输入逻辑错误的范围。

---

## 4. 参考文献 (References)

* **Han, J., Kamber, M., & Pei, J. (2011)**. *Data Mining: Concepts and Techniques* (3rd ed.). Morgan Kaufmann. Section 3.4.1.
    * *注: 这是数据挖掘领域的圣经级教材，引用它能增加包的权威性。*
