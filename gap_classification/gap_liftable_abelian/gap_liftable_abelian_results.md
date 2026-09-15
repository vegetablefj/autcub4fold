# Liftable abelian results

This file records 53 liftable abelian candidates for cubic fourfolds. The 51 ordinary records come from the 32 maximal liftable diagonal types in [Peng--Zheng, Theorem 4.2](../../REFERENCES.md#abelian-actions). The projective actions `C48` and `C32` are added from the special [Yang--Yu--Zhu examples](../../REFERENCES.md#symplectic-actions-and-maximal-groups). This is a candidate list, not a list of 53 certified saturated families.

The ordinary computation retains the order and logic of `gap_liftable_abelian_original.g`: local reduction, order filtering, diagonal-equivalence testing, and the abelian-full-group restrictions. The tables preserve the saved candidate order. See [gap_liftable_abelian_script.md](gap_liftable_abelian_script.md) for the mathematical scope and output fields.

## Run information

- GAP version: `4.15.1`
- Computational core: `gap_liftable_abelian_original.g`
- Order-filtered pool: **1,216**
- Records after equivalence deduplication: **110**
- Ordinary candidates after the final restrictions: **51**
- Special Yang--Yu--Zhu candidates: **2**
- Total candidates: **53**
- Reference-count checks (51 ordinary, 53 total): **passed**
- Total runtime: **121.6 s**
- Saved output: [gap_liftable_abelian.out](gap_liftable_abelian.out)
- Runtime log: [gap_liftable_abelian.log](gap_liftable_abelian.log)
- Machine-readable GAP data: [gap_liftable_abelian_data.g](gap_liftable_abelian_data.g)

> **Notation.** `GL` denotes the linear extension containing the scalar subgroup `mu_3`, while `PGL` denotes its projective image. The recorded family dimension is `dim(invariant cubics) - dim(centralizer in GL_6)`. `Sources merged` counts equivalent raw records merged into the displayed candidate; it need not equal the number of distinct maximal source types.

## Maximal source types

Each ordinary invariant space contains the smooth cubic attached to at least one of its maximal Peng--Zheng source types. Thus no separate smoothness search is needed at this stage.

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:60px; white-space:nowrap;">No.</th>
      <th style="min-width:210px;">Source type</th>
      <th style="width:105px; white-space:nowrap; text-align:right;">Ambient order</th>
      <th style="width:150px; white-space:nowrap; text-align:right;">Containing <code>mu_3</code></th>
      <th style="width:100px; white-space:nowrap; text-align:right;">Essential</th>
      <th style="width:100px; white-space:nowrap; text-align:right;">Retained</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap;"><code>M_1</code></td>
      <td><code>T1+T1+T1+T1+T1+T1</code></td>
      <td style="white-space:nowrap; text-align:right;">729</td>
      <td style="white-space:nowrap; text-align:right;">2664</td>
      <td style="white-space:nowrap; text-align:right;">818</td>
      <td style="white-space:nowrap; text-align:right;">607</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>M_2</code></td>
      <td><code>T2+T1+T1+T1+T1</code></td>
      <td style="white-space:nowrap; text-align:right;">486</td>
      <td style="white-space:nowrap; text-align:right;">424</td>
      <td style="white-space:nowrap; text-align:right;">182</td>
      <td style="white-space:nowrap; text-align:right;">161</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>M_3</code></td>
      <td><code>T2+T2+T1+T1</code></td>
      <td style="white-space:nowrap; text-align:right;">324</td>
      <td style="white-space:nowrap; text-align:right;">140</td>
      <td style="white-space:nowrap; text-align:right;">73</td>
      <td style="white-space:nowrap; text-align:right;">72</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>M_4</code></td>
      <td><code>T2+T2+T2</code></td>
      <td style="white-space:nowrap; text-align:right;">216</td>
      <td style="white-space:nowrap; text-align:right;">96</td>
      <td style="white-space:nowrap; text-align:right;">45</td>
      <td style="white-space:nowrap; text-align:right;">44</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>M_5</code></td>
      <td><code>K3+T1+T1+T1</code></td>
      <td style="white-space:nowrap; text-align:right;">243</td>
      <td style="white-space:nowrap; text-align:right;">50</td>
      <td style="white-space:nowrap; text-align:right;">20</td>
      <td style="white-space:nowrap; text-align:right;">17</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>M_6</code></td>
      <td><code>T3+T1+T1+T1</code></td>
      <td style="white-space:nowrap; text-align:right;">324</td>
      <td style="white-space:nowrap; text-align:right;">84</td>
      <td style="white-space:nowrap; text-align:right;">52</td>
      <td style="white-space:nowrap; text-align:right;">50</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>M_7</code></td>
      <td><code>K3+T2+T1</code></td>
      <td style="white-space:nowrap; text-align:right;">162</td>
      <td style="white-space:nowrap; text-align:right;">20</td>
      <td style="white-space:nowrap; text-align:right;">11</td>
      <td style="white-space:nowrap; text-align:right;">10</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>M_8</code></td>
      <td><code>T3+T2+T1</code></td>
      <td style="white-space:nowrap; text-align:right;">216</td>
      <td style="white-space:nowrap; text-align:right;">48</td>
      <td style="white-space:nowrap; text-align:right;">31</td>
      <td style="white-space:nowrap; text-align:right;">30</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>M_9</code></td>
      <td><code>K3+K3</code></td>
      <td style="white-space:nowrap; text-align:right;">81</td>
      <td style="white-space:nowrap; text-align:right;">10</td>
      <td style="white-space:nowrap; text-align:right;">8</td>
      <td style="white-space:nowrap; text-align:right;">7</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>M_10</code></td>
      <td><code>K3+T3</code></td>
      <td style="white-space:nowrap; text-align:right;">108</td>
      <td style="white-space:nowrap; text-align:right;">9</td>
      <td style="white-space:nowrap; text-align:right;">7</td>
      <td style="white-space:nowrap; text-align:right;">7</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>M_11</code></td>
      <td><code>T3+T3</code></td>
      <td style="white-space:nowrap; text-align:right;">144</td>
      <td style="white-space:nowrap; text-align:right;">30</td>
      <td style="white-space:nowrap; text-align:right;">18</td>
      <td style="white-space:nowrap; text-align:right;">17</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>M_12</code></td>
      <td><code>K4+T1+T1</code></td>
      <td style="white-space:nowrap; text-align:right;">135</td>
      <td style="white-space:nowrap; text-align:right;">12</td>
      <td style="white-space:nowrap; text-align:right;">9</td>
      <td style="white-space:nowrap; text-align:right;">5</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>M_13</code></td>
      <td><code>T4+T1+T1</code></td>
      <td style="white-space:nowrap; text-align:right;">216</td>
      <td style="white-space:nowrap; text-align:right;">24</td>
      <td style="white-space:nowrap; text-align:right;">20</td>
      <td style="white-space:nowrap; text-align:right;">19</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>M_14</code></td>
      <td><code>Y11+T1+T1</code></td>
      <td style="white-space:nowrap; text-align:right;">108</td>
      <td style="white-space:nowrap; text-align:right;">18</td>
      <td style="white-space:nowrap; text-align:right;">15</td>
      <td style="white-space:nowrap; text-align:right;">15</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>M_15</code></td>
      <td><code>K4+T2</code></td>
      <td style="white-space:nowrap; text-align:right;">90</td>
      <td style="white-space:nowrap; text-align:right;">8</td>
      <td style="white-space:nowrap; text-align:right;">6</td>
      <td style="white-space:nowrap; text-align:right;">3</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>M_16</code></td>
      <td><code>T4+T2</code></td>
      <td style="white-space:nowrap; text-align:right;">144</td>
      <td style="white-space:nowrap; text-align:right;">22</td>
      <td style="white-space:nowrap; text-align:right;">15</td>
      <td style="white-space:nowrap; text-align:right;">14</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>M_17</code></td>
      <td><code>Y11+T2</code></td>
      <td style="white-space:nowrap; text-align:right;">72</td>
      <td style="white-space:nowrap; text-align:right;">16</td>
      <td style="white-space:nowrap; text-align:right;">11</td>
      <td style="white-space:nowrap; text-align:right;">11</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>M_18</code></td>
      <td><code>K5+T1</code></td>
      <td style="white-space:nowrap; text-align:right;">99</td>
      <td style="white-space:nowrap; text-align:right;">4</td>
      <td style="white-space:nowrap; text-align:right;">3</td>
      <td style="white-space:nowrap; text-align:right;">2</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>M_19</code></td>
      <td><code>T5+T1</code></td>
      <td style="white-space:nowrap; text-align:right;">144</td>
      <td style="white-space:nowrap; text-align:right;">10</td>
      <td style="white-space:nowrap; text-align:right;">10</td>
      <td style="white-space:nowrap; text-align:right;">9</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>M_20</code></td>
      <td><code>Y21+T1</code></td>
      <td style="white-space:nowrap; text-align:right;">72</td>
      <td style="white-space:nowrap; text-align:right;">8</td>
      <td style="white-space:nowrap; text-align:right;">8</td>
      <td style="white-space:nowrap; text-align:right;">8</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>M_21</code></td>
      <td><code>K6</code></td>
      <td style="white-space:nowrap; text-align:right;">63</td>
      <td style="white-space:nowrap; text-align:right;">4</td>
      <td style="white-space:nowrap; text-align:right;">4</td>
      <td style="white-space:nowrap; text-align:right;">2</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>M_22</code></td>
      <td><code>T6</code></td>
      <td style="white-space:nowrap; text-align:right;">96</td>
      <td style="white-space:nowrap; text-align:right;">6</td>
      <td style="white-space:nowrap; text-align:right;">6</td>
      <td style="white-space:nowrap; text-align:right;">5</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>M_23</code></td>
      <td><code>Y31</code></td>
      <td style="white-space:nowrap; text-align:right;">48</td>
      <td style="white-space:nowrap; text-align:right;">5</td>
      <td style="white-space:nowrap; text-align:right;">5</td>
      <td style="white-space:nowrap; text-align:right;">5</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>M_24</code></td>
      <td><code>Y22</code></td>
      <td style="white-space:nowrap; text-align:right;">48</td>
      <td style="white-space:nowrap; text-align:right;">11</td>
      <td style="white-space:nowrap; text-align:right;">10</td>
      <td style="white-space:nowrap; text-align:right;">10</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>M_25</code></td>
      <td><code>NonSimple-1</code></td>
      <td style="white-space:nowrap; text-align:right;">18</td>
      <td style="white-space:nowrap; text-align:right;">4</td>
      <td style="white-space:nowrap; text-align:right;">4</td>
      <td style="white-space:nowrap; text-align:right;">4</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>M_26</code></td>
      <td><code>NonSimple-2</code></td>
      <td style="white-space:nowrap; text-align:right;">24</td>
      <td style="white-space:nowrap; text-align:right;">4</td>
      <td style="white-space:nowrap; text-align:right;">4</td>
      <td style="white-space:nowrap; text-align:right;">4</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>M_27</code></td>
      <td><code>NonSimple-3</code></td>
      <td style="white-space:nowrap; text-align:right;">24</td>
      <td style="white-space:nowrap; text-align:right;">8</td>
      <td style="white-space:nowrap; text-align:right;">8</td>
      <td style="white-space:nowrap; text-align:right;">8</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>M_28</code></td>
      <td><code>NonSimple-4</code></td>
      <td style="white-space:nowrap; text-align:right;">24</td>
      <td style="white-space:nowrap; text-align:right;">8</td>
      <td style="white-space:nowrap; text-align:right;">8</td>
      <td style="white-space:nowrap; text-align:right;">8</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>M_29</code></td>
      <td><code>NonSimple-5</code></td>
      <td style="white-space:nowrap; text-align:right;">24</td>
      <td style="white-space:nowrap; text-align:right;">8</td>
      <td style="white-space:nowrap; text-align:right;">8</td>
      <td style="white-space:nowrap; text-align:right;">8</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>M_30</code></td>
      <td><code>NonSimple-6</code></td>
      <td style="white-space:nowrap; text-align:right;">24</td>
      <td style="white-space:nowrap; text-align:right;">8</td>
      <td style="white-space:nowrap; text-align:right;">8</td>
      <td style="white-space:nowrap; text-align:right;">8</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>M_31</code></td>
      <td><code>NonSimple-7</code></td>
      <td style="white-space:nowrap; text-align:right;">108</td>
      <td style="white-space:nowrap; text-align:right;">30</td>
      <td style="white-space:nowrap; text-align:right;">25</td>
      <td style="white-space:nowrap; text-align:right;">25</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>M_32</code></td>
      <td><code>NonSimple-8</code></td>
      <td style="white-space:nowrap; text-align:right;">72</td>
      <td style="white-space:nowrap; text-align:right;">32</td>
      <td style="white-space:nowrap; text-align:right;">21</td>
      <td style="white-space:nowrap; text-align:right;">21</td>
    </tr>
  </tbody>
</table>

## Candidate overview

Rows `LA-001` and `LA-002` are the special `C48` and `C32` examples. Rows `LA-003`--`LA-053` are the 51 ordinary equivalence classes returned by the original core.

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:85px; white-space:nowrap;">Label</th>
      <th style="min-width:125px;">PGL structure</th>
      <th style="width:75px; white-space:nowrap; text-align:right;">PGL order</th>
      <th style="width:105px; white-space:nowrap;">PGL ID</th>
      <th style="min-width:135px;">GL structure</th>
      <th style="width:75px; white-space:nowrap; text-align:right;">GL order</th>
      <th style="width:105px; white-space:nowrap;">GL ID</th>
      <th style="width:75px; white-space:nowrap; text-align:right;">Family dim.</th>
      <th style="min-width:150px;">Source</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap;"><code>LA-001</code> *</td>
      <td><code>C48</code></td>
      <td style="white-space:nowrap; text-align:right;">48</td>
      <td style="white-space:nowrap;"><code>[48,2]</code></td>
      <td><code>C48 x C3</code></td>
      <td style="white-space:nowrap; text-align:right;">144</td>
      <td style="white-space:nowrap;"><code>[144,30]</code></td>
      <td style="white-space:nowrap; text-align:right;">0</td>
      <td><code>YYZ-X5-prime-C48</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-002</code> *</td>
      <td><code>C32</code></td>
      <td style="white-space:nowrap; text-align:right;">32</td>
      <td style="white-space:nowrap;"><code>[32,1]</code></td>
      <td><code>C96</code></td>
      <td style="white-space:nowrap; text-align:right;">96</td>
      <td style="white-space:nowrap;"><code>[96,2]</code></td>
      <td style="white-space:nowrap; text-align:right;">0</td>
      <td><code>YYZ-X8-prime-C32</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-003</code></td>
      <td><code>1</code></td>
      <td style="white-space:nowrap; text-align:right;">1</td>
      <td style="white-space:nowrap;"><code>[1,1]</code></td>
      <td><code>C3</code></td>
      <td style="white-space:nowrap; text-align:right;">3</td>
      <td style="white-space:nowrap;"><code>[3,1]</code></td>
      <td style="white-space:nowrap; text-align:right;">20</td>
      <td><code>32 maximal types</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-004</code></td>
      <td><code>C2</code></td>
      <td style="white-space:nowrap; text-align:right;">2</td>
      <td style="white-space:nowrap;"><code>[2,1]</code></td>
      <td><code>C6</code></td>
      <td style="white-space:nowrap; text-align:right;">6</td>
      <td style="white-space:nowrap;"><code>[6,2]</code></td>
      <td style="white-space:nowrap; text-align:right;">14</td>
      <td><code>19 maximal types</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-005</code></td>
      <td><code>C2</code></td>
      <td style="white-space:nowrap; text-align:right;">2</td>
      <td style="white-space:nowrap;"><code>[2,1]</code></td>
      <td><code>C6</code></td>
      <td style="white-space:nowrap; text-align:right;">6</td>
      <td style="white-space:nowrap;"><code>[6,2]</code></td>
      <td style="white-space:nowrap; text-align:right;">12</td>
      <td><code>15 maximal types</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-006</code></td>
      <td><code>C2 x C2</code></td>
      <td style="white-space:nowrap; text-align:right;">4</td>
      <td style="white-space:nowrap;"><code>[4,2]</code></td>
      <td><code>C6 x C2</code></td>
      <td style="white-space:nowrap; text-align:right;">12</td>
      <td style="white-space:nowrap;"><code>[12,5]</code></td>
      <td style="white-space:nowrap; text-align:right;">10</td>
      <td><code>6 maximal types</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-007</code></td>
      <td><code>C3</code></td>
      <td style="white-space:nowrap; text-align:right;">3</td>
      <td style="white-space:nowrap;"><code>[3,1]</code></td>
      <td><code>C3 x C3</code></td>
      <td style="white-space:nowrap; text-align:right;">9</td>
      <td style="white-space:nowrap;"><code>[9,2]</code></td>
      <td style="white-space:nowrap; text-align:right;">10</td>
      <td><code>14 maximal types</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-008</code></td>
      <td><code>C2</code></td>
      <td style="white-space:nowrap; text-align:right;">2</td>
      <td style="white-space:nowrap;"><code>[2,1]</code></td>
      <td><code>C6</code></td>
      <td style="white-space:nowrap; text-align:right;">6</td>
      <td style="white-space:nowrap;"><code>[6,2]</code></td>
      <td style="white-space:nowrap; text-align:right;">10</td>
      <td><code>7 maximal types</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-009</code></td>
      <td><code>C2 x C2</code></td>
      <td style="white-space:nowrap; text-align:right;">4</td>
      <td style="white-space:nowrap;"><code>[4,2]</code></td>
      <td><code>C6 x C2</code></td>
      <td style="white-space:nowrap; text-align:right;">12</td>
      <td style="white-space:nowrap;"><code>[12,5]</code></td>
      <td style="white-space:nowrap; text-align:right;">8</td>
      <td><code>4 maximal types</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-010</code></td>
      <td><code>C2 x C2</code></td>
      <td style="white-space:nowrap; text-align:right;">4</td>
      <td style="white-space:nowrap;"><code>[4,2]</code></td>
      <td><code>C6 x C2</code></td>
      <td style="white-space:nowrap; text-align:right;">12</td>
      <td style="white-space:nowrap;"><code>[12,5]</code></td>
      <td style="white-space:nowrap; text-align:right;">8</td>
      <td><code>4 maximal types</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-011</code></td>
      <td><code>C3</code></td>
      <td style="white-space:nowrap; text-align:right;">3</td>
      <td style="white-space:nowrap;"><code>[3,1]</code></td>
      <td><code>C3 x C3</code></td>
      <td style="white-space:nowrap; text-align:right;">9</td>
      <td style="white-space:nowrap;"><code>[9,2]</code></td>
      <td style="white-space:nowrap; text-align:right;">8</td>
      <td><code>4 maximal types</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-012</code></td>
      <td><code>C2 x C2 x C2</code></td>
      <td style="white-space:nowrap; text-align:right;">8</td>
      <td style="white-space:nowrap;"><code>[8,5]</code></td>
      <td><code>C6 x C2 x C2</code></td>
      <td style="white-space:nowrap; text-align:right;">24</td>
      <td style="white-space:nowrap;"><code>[24,15]</code></td>
      <td style="white-space:nowrap; text-align:right;">7</td>
      <td><code>T2+T2+T2</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-013</code></td>
      <td><code>C6</code></td>
      <td style="white-space:nowrap; text-align:right;">6</td>
      <td style="white-space:nowrap;"><code>[6,2]</code></td>
      <td><code>C6 x C3</code></td>
      <td style="white-space:nowrap; text-align:right;">18</td>
      <td style="white-space:nowrap;"><code>[18,5]</code></td>
      <td style="white-space:nowrap; text-align:right;">7</td>
      <td><code>8 maximal types</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-014</code></td>
      <td><code>C4</code></td>
      <td style="white-space:nowrap; text-align:right;">4</td>
      <td style="white-space:nowrap;"><code>[4,1]</code></td>
      <td><code>C12</code></td>
      <td style="white-space:nowrap; text-align:right;">12</td>
      <td style="white-space:nowrap;"><code>[12,2]</code></td>
      <td style="white-space:nowrap; text-align:right;">7</td>
      <td><code>9 maximal types</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-015</code></td>
      <td><code>C4</code></td>
      <td style="white-space:nowrap; text-align:right;">4</td>
      <td style="white-space:nowrap;"><code>[4,1]</code></td>
      <td><code>C12</code></td>
      <td style="white-space:nowrap; text-align:right;">12</td>
      <td style="white-space:nowrap;"><code>[12,2]</code></td>
      <td style="white-space:nowrap; text-align:right;">7</td>
      <td><code>5 maximal types</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-016</code></td>
      <td><code>C3</code></td>
      <td style="white-space:nowrap; text-align:right;">3</td>
      <td style="white-space:nowrap;"><code>[3,1]</code></td>
      <td><code>C3 x C3</code></td>
      <td style="white-space:nowrap; text-align:right;">9</td>
      <td style="white-space:nowrap;"><code>[9,2]</code></td>
      <td style="white-space:nowrap; text-align:right;">7</td>
      <td><code>7 maximal types</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-017</code></td>
      <td><code>C6</code></td>
      <td style="white-space:nowrap; text-align:right;">6</td>
      <td style="white-space:nowrap;"><code>[6,2]</code></td>
      <td><code>C6 x C3</code></td>
      <td style="white-space:nowrap; text-align:right;">18</td>
      <td style="white-space:nowrap;"><code>[18,5]</code></td>
      <td style="white-space:nowrap; text-align:right;">6</td>
      <td><code>4 maximal types</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-018</code></td>
      <td><code>C4</code></td>
      <td style="white-space:nowrap; text-align:right;">4</td>
      <td style="white-space:nowrap;"><code>[4,1]</code></td>
      <td><code>C12</code></td>
      <td style="white-space:nowrap; text-align:right;">12</td>
      <td style="white-space:nowrap;"><code>[12,2]</code></td>
      <td style="white-space:nowrap; text-align:right;">6</td>
      <td><code>5 maximal types</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-019</code></td>
      <td><code>C2 x C2</code></td>
      <td style="white-space:nowrap; text-align:right;">4</td>
      <td style="white-space:nowrap;"><code>[4,2]</code></td>
      <td><code>C6 x C2</code></td>
      <td style="white-space:nowrap; text-align:right;">12</td>
      <td style="white-space:nowrap;"><code>[12,5]</code></td>
      <td style="white-space:nowrap; text-align:right;">6</td>
      <td><code>NonSimple-5, NonSimple-6, NonSimple-8</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-020</code></td>
      <td><code>C3</code></td>
      <td style="white-space:nowrap; text-align:right;">3</td>
      <td style="white-space:nowrap;"><code>[3,1]</code></td>
      <td><code>C9</code></td>
      <td style="white-space:nowrap; text-align:right;">9</td>
      <td style="white-space:nowrap;"><code>[9,1]</code></td>
      <td style="white-space:nowrap; text-align:right;">6</td>
      <td><code>K3+K3, K6, NonSimple-1</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-021</code></td>
      <td><code>C6 x C2</code></td>
      <td style="white-space:nowrap; text-align:right;">12</td>
      <td style="white-space:nowrap;"><code>[12,5]</code></td>
      <td><code>C6 x C6</code></td>
      <td style="white-space:nowrap; text-align:right;">36</td>
      <td style="white-space:nowrap;"><code>[36,14]</code></td>
      <td style="white-space:nowrap; text-align:right;">5</td>
      <td><code>T2+T2+T1+T1, T3+T2+T1</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-022</code></td>
      <td><code>C4 x C2</code></td>
      <td style="white-space:nowrap; text-align:right;">8</td>
      <td style="white-space:nowrap;"><code>[8,2]</code></td>
      <td><code>C12 x C2</code></td>
      <td style="white-space:nowrap; text-align:right;">24</td>
      <td style="white-space:nowrap;"><code>[24,9]</code></td>
      <td style="white-space:nowrap; text-align:right;">5</td>
      <td><code>T3+T2+T1, T3+T3, T4+T2</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-023</code></td>
      <td><code>C2 x C2 x C2</code></td>
      <td style="white-space:nowrap; text-align:right;">8</td>
      <td style="white-space:nowrap;"><code>[8,5]</code></td>
      <td><code>C6 x C2 x C2</code></td>
      <td style="white-space:nowrap; text-align:right;">24</td>
      <td style="white-space:nowrap;"><code>[24,15]</code></td>
      <td style="white-space:nowrap; text-align:right;">5</td>
      <td><code>NonSimple-8</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-024</code></td>
      <td><code>C6</code></td>
      <td style="white-space:nowrap; text-align:right;">6</td>
      <td style="white-space:nowrap;"><code>[6,2]</code></td>
      <td><code>C6 x C3</code></td>
      <td style="white-space:nowrap; text-align:right;">18</td>
      <td style="white-space:nowrap;"><code>[18,5]</code></td>
      <td style="white-space:nowrap; text-align:right;">5</td>
      <td><code>4 maximal types</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-025</code></td>
      <td><code>C6 x C2</code></td>
      <td style="white-space:nowrap; text-align:right;">12</td>
      <td style="white-space:nowrap;"><code>[12,5]</code></td>
      <td><code>C6 x C6</code></td>
      <td style="white-space:nowrap; text-align:right;">36</td>
      <td style="white-space:nowrap;"><code>[36,14]</code></td>
      <td style="white-space:nowrap; text-align:right;">4</td>
      <td><code>NonSimple-7</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-026</code></td>
      <td><code>C3 x C3</code></td>
      <td style="white-space:nowrap; text-align:right;">9</td>
      <td style="white-space:nowrap;"><code>[9,2]</code></td>
      <td><code>C3 x C3 x C3</code></td>
      <td style="white-space:nowrap; text-align:right;">27</td>
      <td style="white-space:nowrap;"><code>[27,5]</code></td>
      <td style="white-space:nowrap; text-align:right;">4</td>
      <td><code>T1+T1+T1+T1+T1+T1, T2+T1+T1+T1+T1, T2+T2+T1+T1</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-027</code></td>
      <td><code>C4 x C2</code></td>
      <td style="white-space:nowrap; text-align:right;">8</td>
      <td style="white-space:nowrap;"><code>[8,2]</code></td>
      <td><code>C12 x C2</code></td>
      <td style="white-space:nowrap; text-align:right;">24</td>
      <td style="white-space:nowrap;"><code>[24,9]</code></td>
      <td style="white-space:nowrap; text-align:right;">4</td>
      <td><code>NonSimple-3</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-028</code></td>
      <td><code>C4 x C2</code></td>
      <td style="white-space:nowrap; text-align:right;">8</td>
      <td style="white-space:nowrap;"><code>[8,2]</code></td>
      <td><code>C12 x C2</code></td>
      <td style="white-space:nowrap; text-align:right;">24</td>
      <td style="white-space:nowrap;"><code>[24,9]</code></td>
      <td style="white-space:nowrap; text-align:right;">4</td>
      <td><code>T3+T3, Y22</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-029</code></td>
      <td><code>C6</code></td>
      <td style="white-space:nowrap; text-align:right;">6</td>
      <td style="white-space:nowrap;"><code>[6,2]</code></td>
      <td><code>C6 x C3</code></td>
      <td style="white-space:nowrap; text-align:right;">18</td>
      <td style="white-space:nowrap;"><code>[18,5]</code></td>
      <td style="white-space:nowrap; text-align:right;">4</td>
      <td><code>4 maximal types</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-030</code></td>
      <td><code>C6</code></td>
      <td style="white-space:nowrap; text-align:right;">6</td>
      <td style="white-space:nowrap;"><code>[6,2]</code></td>
      <td><code>C6 x C3</code></td>
      <td style="white-space:nowrap; text-align:right;">18</td>
      <td style="white-space:nowrap;"><code>[18,5]</code></td>
      <td style="white-space:nowrap; text-align:right;">4</td>
      <td><code>T2+T1+T1+T1+T1, T2+T2+T1+T1, T2+T2+T2</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-031</code></td>
      <td><code>C6</code></td>
      <td style="white-space:nowrap; text-align:right;">6</td>
      <td style="white-space:nowrap;"><code>[6,2]</code></td>
      <td><code>C6 x C3</code></td>
      <td style="white-space:nowrap; text-align:right;">18</td>
      <td style="white-space:nowrap;"><code>[18,5]</code></td>
      <td style="white-space:nowrap; text-align:right;">4</td>
      <td><code>T2+T2+T1+T1, T3+T2+T1</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-032</code></td>
      <td><code>C6</code></td>
      <td style="white-space:nowrap; text-align:right;">6</td>
      <td style="white-space:nowrap;"><code>[6,2]</code></td>
      <td><code>C6 x C3</code></td>
      <td style="white-space:nowrap; text-align:right;">18</td>
      <td style="white-space:nowrap;"><code>[18,5]</code></td>
      <td style="white-space:nowrap; text-align:right;">4</td>
      <td><code>T2+T2+T2</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-033</code></td>
      <td><code>C4</code></td>
      <td style="white-space:nowrap; text-align:right;">4</td>
      <td style="white-space:nowrap;"><code>[4,1]</code></td>
      <td><code>C12</code></td>
      <td style="white-space:nowrap; text-align:right;">12</td>
      <td style="white-space:nowrap;"><code>[12,2]</code></td>
      <td style="white-space:nowrap; text-align:right;">4</td>
      <td><code>4 maximal types</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-034</code></td>
      <td><code>C12</code></td>
      <td style="white-space:nowrap; text-align:right;">12</td>
      <td style="white-space:nowrap;"><code>[12,2]</code></td>
      <td><code>C12 x C3</code></td>
      <td style="white-space:nowrap; text-align:right;">36</td>
      <td style="white-space:nowrap;"><code>[36,8]</code></td>
      <td style="white-space:nowrap; text-align:right;">3</td>
      <td><code>4 maximal types</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-035</code></td>
      <td><code>C12</code></td>
      <td style="white-space:nowrap; text-align:right;">12</td>
      <td style="white-space:nowrap;"><code>[12,2]</code></td>
      <td><code>C12 x C3</code></td>
      <td style="white-space:nowrap; text-align:right;">36</td>
      <td style="white-space:nowrap;"><code>[36,8]</code></td>
      <td style="white-space:nowrap; text-align:right;">3</td>
      <td><code>T3+T2+T1, Y21+T1</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-036</code></td>
      <td><code>C6 x C2</code></td>
      <td style="white-space:nowrap; text-align:right;">12</td>
      <td style="white-space:nowrap;"><code>[12,5]</code></td>
      <td><code>C6 x C6</code></td>
      <td style="white-space:nowrap; text-align:right;">36</td>
      <td style="white-space:nowrap;"><code>[36,14]</code></td>
      <td style="white-space:nowrap; text-align:right;">3</td>
      <td><code>T2+T2+T1+T1, T3+T2+T1</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-037</code></td>
      <td><code>C3 x C3</code></td>
      <td style="white-space:nowrap; text-align:right;">9</td>
      <td style="white-space:nowrap;"><code>[9,2]</code></td>
      <td><code>C3 x C3 x C3</code></td>
      <td style="white-space:nowrap; text-align:right;">27</td>
      <td style="white-space:nowrap;"><code>[27,5]</code></td>
      <td style="white-space:nowrap; text-align:right;">3</td>
      <td><code>T1+T1+T1+T1+T1+T1</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-038</code></td>
      <td><code>C8</code></td>
      <td style="white-space:nowrap; text-align:right;">8</td>
      <td style="white-space:nowrap;"><code>[8,1]</code></td>
      <td><code>C24</code></td>
      <td style="white-space:nowrap; text-align:right;">24</td>
      <td style="white-space:nowrap;"><code>[24,2]</code></td>
      <td style="white-space:nowrap; text-align:right;">3</td>
      <td><code>4 maximal types</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-039</code></td>
      <td><code>C8</code></td>
      <td style="white-space:nowrap; text-align:right;">8</td>
      <td style="white-space:nowrap;"><code>[8,1]</code></td>
      <td><code>C24</code></td>
      <td style="white-space:nowrap; text-align:right;">24</td>
      <td style="white-space:nowrap;"><code>[24,2]</code></td>
      <td style="white-space:nowrap; text-align:right;">3</td>
      <td><code>T4+T2, Y31</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-040</code></td>
      <td><code>C8</code></td>
      <td style="white-space:nowrap; text-align:right;">8</td>
      <td style="white-space:nowrap;"><code>[8,1]</code></td>
      <td><code>C24</code></td>
      <td style="white-space:nowrap; text-align:right;">24</td>
      <td style="white-space:nowrap;"><code>[24,2]</code></td>
      <td style="white-space:nowrap; text-align:right;">3</td>
      <td><code>Y21+T1</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-041</code></td>
      <td><code>C6</code></td>
      <td style="white-space:nowrap; text-align:right;">6</td>
      <td style="white-space:nowrap;"><code>[6,2]</code></td>
      <td><code>C18</code></td>
      <td style="white-space:nowrap; text-align:right;">18</td>
      <td style="white-space:nowrap;"><code>[18,2]</code></td>
      <td style="white-space:nowrap; text-align:right;">3</td>
      <td><code>NonSimple-1</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-042</code></td>
      <td><code>C12 x C2</code></td>
      <td style="white-space:nowrap; text-align:right;">24</td>
      <td style="white-space:nowrap;"><code>[24,9]</code></td>
      <td><code>C12 x C6</code></td>
      <td style="white-space:nowrap; text-align:right;">72</td>
      <td style="white-space:nowrap;"><code>[72,36]</code></td>
      <td style="white-space:nowrap; text-align:right;">2</td>
      <td><code>T3+T2+T1</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-043</code></td>
      <td><code>C6 x C3</code></td>
      <td style="white-space:nowrap; text-align:right;">18</td>
      <td style="white-space:nowrap;"><code>[18,5]</code></td>
      <td><code>C6 x C3 x C3</code></td>
      <td style="white-space:nowrap; text-align:right;">54</td>
      <td style="white-space:nowrap;"><code>[54,15]</code></td>
      <td style="white-space:nowrap; text-align:right;">2</td>
      <td><code>T2+T1+T1+T1+T1, T2+T2+T1+T1</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-044</code></td>
      <td><code>C4 x C4</code></td>
      <td style="white-space:nowrap; text-align:right;">16</td>
      <td style="white-space:nowrap;"><code>[16,2]</code></td>
      <td><code>C12 x C4</code></td>
      <td style="white-space:nowrap; text-align:right;">48</td>
      <td style="white-space:nowrap;"><code>[48,20]</code></td>
      <td style="white-space:nowrap; text-align:right;">2</td>
      <td><code>T3+T3</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-045</code></td>
      <td><code>C8 x C2</code></td>
      <td style="white-space:nowrap; text-align:right;">16</td>
      <td style="white-space:nowrap;"><code>[16,5]</code></td>
      <td><code>C24 x C2</code></td>
      <td style="white-space:nowrap; text-align:right;">48</td>
      <td style="white-space:nowrap;"><code>[48,23]</code></td>
      <td style="white-space:nowrap; text-align:right;">2</td>
      <td><code>T4+T2</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-046</code></td>
      <td><code>C12</code></td>
      <td style="white-space:nowrap; text-align:right;">12</td>
      <td style="white-space:nowrap;"><code>[12,2]</code></td>
      <td><code>C12 x C3</code></td>
      <td style="white-space:nowrap; text-align:right;">36</td>
      <td style="white-space:nowrap;"><code>[36,8]</code></td>
      <td style="white-space:nowrap; text-align:right;">2</td>
      <td><code>T3+T1+T1+T1, T3+T2+T1</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-047</code></td>
      <td><code>C12</code></td>
      <td style="white-space:nowrap; text-align:right;">12</td>
      <td style="white-space:nowrap;"><code>[12,2]</code></td>
      <td><code>C12 x C3</code></td>
      <td style="white-space:nowrap; text-align:right;">36</td>
      <td style="white-space:nowrap;"><code>[36,8]</code></td>
      <td style="white-space:nowrap; text-align:right;">2</td>
      <td><code>T3+T2+T1</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-048</code></td>
      <td><code>C4 x C2</code></td>
      <td style="white-space:nowrap; text-align:right;">8</td>
      <td style="white-space:nowrap;"><code>[8,2]</code></td>
      <td><code>C12 x C2</code></td>
      <td style="white-space:nowrap; text-align:right;">24</td>
      <td style="white-space:nowrap;"><code>[24,9]</code></td>
      <td style="white-space:nowrap; text-align:right;">2</td>
      <td><code>NonSimple-5, NonSimple-6</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-049</code></td>
      <td><code>C12 x C2</code></td>
      <td style="white-space:nowrap; text-align:right;">24</td>
      <td style="white-space:nowrap;"><code>[24,9]</code></td>
      <td><code>C12 x C6</code></td>
      <td style="white-space:nowrap; text-align:right;">72</td>
      <td style="white-space:nowrap;"><code>[72,36]</code></td>
      <td style="white-space:nowrap; text-align:right;">1</td>
      <td><code>T3+T2+T1</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-050</code></td>
      <td><code>C24</code></td>
      <td style="white-space:nowrap; text-align:right;">24</td>
      <td style="white-space:nowrap;"><code>[24,2]</code></td>
      <td><code>C24 x C3</code></td>
      <td style="white-space:nowrap; text-align:right;">72</td>
      <td style="white-space:nowrap;"><code>[72,14]</code></td>
      <td style="white-space:nowrap; text-align:right;">1</td>
      <td><code>T4+T1+T1, T5+T1</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-051</code></td>
      <td><code>C24</code></td>
      <td style="white-space:nowrap; text-align:right;">24</td>
      <td style="white-space:nowrap;"><code>[24,2]</code></td>
      <td><code>C24 x C3</code></td>
      <td style="white-space:nowrap; text-align:right;">72</td>
      <td style="white-space:nowrap;"><code>[72,14]</code></td>
      <td style="white-space:nowrap; text-align:right;">1</td>
      <td><code>Y21+T1</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-052</code></td>
      <td><code>C16</code></td>
      <td style="white-space:nowrap; text-align:right;">16</td>
      <td style="white-space:nowrap;"><code>[16,1]</code></td>
      <td><code>C48</code></td>
      <td style="white-space:nowrap; text-align:right;">48</td>
      <td style="white-space:nowrap;"><code>[48,2]</code></td>
      <td style="white-space:nowrap; text-align:right;">1</td>
      <td><code>T5+T1, T6</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>LA-053</code></td>
      <td><code>C16</code></td>
      <td style="white-space:nowrap; text-align:right;">16</td>
      <td style="white-space:nowrap;"><code>[16,1]</code></td>
      <td><code>C48</code></td>
      <td style="white-space:nowrap; text-align:right;">48</td>
      <td style="white-space:nowrap;"><code>[48,2]</code></td>
      <td style="white-space:nowrap; text-align:right;">1</td>
      <td><code>Y31</code></td>
    </tr>
  </tbody>
</table>

\* Special Yang--Yu--Zhu example.

## Detailed results

### `LA-001` — `C48` (special Yang--Yu--Zhu example)

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">144</td>
      <td style="white-space:nowrap;"><code>[144,30]</code></td>
      <td><code>C48 x C3</code></td>
      <td><code>[ 3, 3, 16 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">48</td>
      <td style="white-space:nowrap;"><code>[48,2]</code></td>
      <td><code>C48</code></td>
      <td><code>[ 3, 16 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **6**, centralizer in \(\mathrm{GL}_6\) **6**, family **0**.
- Determinant-one subgroup order: **3**.
- Sources merged: **1**.
- Source: Yang--Yu--Zhu Examples 6.1 (5) and 6.11.
- Maximal source type(s): <code>YYZ-X5-prime-C48</code>.
- References: Yang--Yu--Zhu, Example 6.1 (5); Yang--Yu--Zhu, Example 6.11.

Invariant cubic basis (6 monomials):

```text
x1^2*x2, x2^2*x3, x3^2*x4, x4^2*x5, x5^3, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(16), 0, 0, 0, 0, 0 ], [ 0, -E(8)^3, 0, 0, 0, 0 ], [ 0, 0, E(4), 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], 
      [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ] ]
```

</details>

### `LA-002` — `C32` (special Yang--Yu--Zhu example)

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">96</td>
      <td style="white-space:nowrap;"><code>[96,2]</code></td>
      <td><code>C96</code></td>
      <td><code>[ 3, 32 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">32</td>
      <td style="white-space:nowrap;"><code>[32,1]</code></td>
      <td><code>C32</code></td>
      <td><code>[ 32 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **6**, centralizer in \(\mathrm{GL}_6\) **6**, family **0**.
- Determinant-one subgroup order: **3**.
- Sources merged: **1**.
- Source: Yang--Yu--Zhu Example 6.1 (8).
- Maximal source type(s): <code>YYZ-X8-prime-C32</code>.
- References: Yang--Yu--Zhu, Example 6.1 (8).

Invariant cubic basis (6 monomials):

```text
x1^2*x2, x2^2*x3, x3^2*x4, x4^2*x5, x5^2*x6, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(32), 0, 0, 0, 0, 0 ], [ 0, -E(16)^7, 0, 0, 0, 0 ], [ 0, 0, E(8), 0, 0, 0 ], [ 0, 0, 0, -E(4), 0, 0 ], 
      [ 0, 0, 0, 0, -1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ], 
  [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ] ]
```

</details>

### `LA-003` — `1`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">3</td>
      <td style="white-space:nowrap;"><code>[3,1]</code></td>
      <td><code>C3</code></td>
      <td><code>[ 3 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">1</td>
      <td style="white-space:nowrap;"><code>[1,1]</code></td>
      <td><code>1</code></td>
      <td><code>[ ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **56**, centralizer in \(\mathrm{GL}_6\) **36**, family **20**.
- Determinant-one subgroup order: **3**.
- Sources merged: **32**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>K3+K3</code>, <code>K3+T1+T1+T1</code>, <code>K3+T2+T1</code>, <code>K3+T3</code>, <code>K4+T1+T1</code>, <code>K4+T2</code>, <code>K5+T1</code>, <code>K6</code>, <code>NonSimple-1</code>, <code>NonSimple-2</code>, <code>NonSimple-3</code>, <code>NonSimple-4</code>, <code>NonSimple-5</code>, <code>NonSimple-6</code>, <code>NonSimple-7</code>, <code>NonSimple-8</code>, <code>T1+T1+T1+T1+T1+T1</code>, <code>T2+T1+T1+T1+T1</code>, <code>T2+T2+T1+T1</code>, <code>T2+T2+T2</code>, <code>T3+T1+T1+T1</code>, <code>T3+T2+T1</code>, <code>T3+T3</code>, <code>T4+T1+T1</code>, <code>T4+T2</code>, <code>T5+T1</code>, <code>T6</code>, <code>Y11+T1+T1</code>, <code>Y11+T2</code>, <code>Y21+T1</code>, <code>Y22</code>, <code>Y31</code>.

Invariant cubic basis (56 monomials):

```text
x1^3, x1^2*x2, x1^2*x3, x1^2*x4, x1^2*x5, x1^2*x6, x1*x2^2, x1*x2*x3, x1*x2*x4, x1*x2*x5, x1*x2*x6, x1*x3^2, x1*x3*x4, x1*x3*x5, x1*x3*x6, x1*x4^2, x1*x4*x5, x1*x4*x6, x1*x5^2, x1*x5*x6, x1*x6^2, x2^3, x2^2*x3, x2^2*x4, x2^2*x5, x2^2*x6, x2*x3^2, x2*x3*x4, x2*x3*x5, x2*x3*x6, x2*x4^2, x2*x4*x5, x2*x4*x6, x2*x5^2, x2*x5*x6, x2*x6^2, x3^3, x3^2*x4, x3^2*x5, x3^2*x6, x3*x4^2, x3*x4*x5, x3*x4*x6, x3*x5^2, x3*x5*x6, x3*x6^2, x4^3, x4^2*x5, x4^2*x6, x4*x5^2, x4*x5*x6, x4*x6^2, x5^3, x5^2*x6, x5*x6^2, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ] ]
```

</details>

### `LA-004` — `C2`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">6</td>
      <td style="white-space:nowrap;"><code>[6,2]</code></td>
      <td><code>C6</code></td>
      <td><code>[ 2, 3 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">2</td>
      <td style="white-space:nowrap;"><code>[2,1]</code></td>
      <td><code>C2</code></td>
      <td><code>[ 2 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **40**, centralizer in \(\mathrm{GL}_6\) **26**, family **14**.
- Determinant-one subgroup order: **3**.
- Sources merged: **26**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>K3+T2+T1</code>, <code>K3+T3</code>, <code>K4+T2</code>, <code>NonSimple-3</code>, <code>NonSimple-8</code>, <code>T2+T1+T1+T1+T1</code>, <code>T2+T2+T1+T1</code>, <code>T2+T2+T2</code>, <code>T3+T1+T1+T1</code>, <code>T3+T2+T1</code>, <code>T3+T3</code>, <code>T4+T1+T1</code>, <code>T4+T2</code>, <code>T5+T1</code>, <code>T6</code>, <code>Y11+T2</code>, <code>Y21+T1</code>, <code>Y22</code>, <code>Y31</code>.

Invariant cubic basis (40 monomials):

```text
x1^3, x1^2*x2, x1^2*x3, x1^2*x5, x1^2*x6, x1*x2^2, x1*x2*x3, x1*x2*x5, x1*x2*x6, x1*x3^2, x1*x3*x5, x1*x3*x6, x1*x4^2, x1*x5^2, x1*x5*x6, x1*x6^2, x2^3, x2^2*x3, x2^2*x5, x2^2*x6, x2*x3^2, x2*x3*x5, x2*x3*x6, x2*x4^2, x2*x5^2, x2*x5*x6, x2*x6^2, x3^3, x3^2*x5, x3^2*x6, x3*x4^2, x3*x5^2, x3*x5*x6, x3*x6^2, x4^2*x5, x4^2*x6, x5^3, x5^2*x6, x5*x6^2, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-005` — `C2`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">6</td>
      <td style="white-space:nowrap;"><code>[6,2]</code></td>
      <td><code>C6</code></td>
      <td><code>[ 2, 3 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">2</td>
      <td style="white-space:nowrap;"><code>[2,1]</code></td>
      <td><code>C2</code></td>
      <td><code>[ 2 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **32**, centralizer in \(\mathrm{GL}_6\) **20**, family **12**.
- Determinant-one subgroup order: **6**.
- Sources merged: **23**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>NonSimple-2</code>, <code>NonSimple-3</code>, <code>NonSimple-4</code>, <code>NonSimple-5</code>, <code>NonSimple-6</code>, <code>NonSimple-7</code>, <code>NonSimple-8</code>, <code>T2+T2+T1+T1</code>, <code>T2+T2+T2</code>, <code>T3+T2+T1</code>, <code>T3+T3</code>, <code>T4+T2</code>, <code>Y11+T1+T1</code>, <code>Y11+T2</code>, <code>Y22</code>.

Invariant cubic basis (32 monomials):

```text
x1^2*x2, x1^2*x4, x1^2*x5, x1^2*x6, x1*x2*x3, x1*x3*x4, x1*x3*x5, x1*x3*x6, x2^3, x2^2*x4, x2^2*x5, x2^2*x6, x2*x3^2, x2*x4^2, x2*x4*x5, x2*x4*x6, x2*x5^2, x2*x5*x6, x2*x6^2, x3^2*x4, x3^2*x5, x3^2*x6, x4^3, x4^2*x5, x4^2*x6, x4*x5^2, x4*x5*x6, x4*x6^2, x5^3, x5^2*x6, x5*x6^2, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-006` — `C2 x C2`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">12</td>
      <td style="white-space:nowrap;"><code>[12,5]</code></td>
      <td><code>C6 x C2</code></td>
      <td><code>[ 2, 2, 3 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">4</td>
      <td style="white-space:nowrap;"><code>[4,2]</code></td>
      <td><code>C2 x C2</code></td>
      <td><code>[ 2, 2 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **28**, centralizer in \(\mathrm{GL}_6\) **18**, family **10**.
- Determinant-one subgroup order: **6**.
- Sources merged: **8**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>T2+T2+T1+T1</code>, <code>T2+T2+T2</code>, <code>T3+T2+T1</code>, <code>T3+T3</code>, <code>T4+T2</code>, <code>Y22</code>.

Invariant cubic basis (28 monomials):

```text
x1^2*x2, x1^2*x4, x1^2*x5, x1^2*x6, x2^3, x2^2*x4, x2^2*x5, x2^2*x6, x2*x3^2, x2*x4^2, x2*x4*x5, x2*x4*x6, x2*x5^2, x2*x5*x6, x2*x6^2, x3^2*x4, x3^2*x5, x3^2*x6, x4^3, x4^2*x5, x4^2*x6, x4*x5^2, x4*x5*x6, x4*x6^2, x5^3, x5^2*x6, x5*x6^2, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ], [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], 
      [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-007` — `C3`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">9</td>
      <td style="white-space:nowrap;"><code>[9,2]</code></td>
      <td><code>C3 x C3</code></td>
      <td><code>[ 3, 3 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">3</td>
      <td style="white-space:nowrap;"><code>[3,1]</code></td>
      <td><code>C3</code></td>
      <td><code>[ 3 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **36**, centralizer in \(\mathrm{GL}_6\) **26**, family **10**.
- Determinant-one subgroup order: **3**.
- Sources merged: **31**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>K3+T1+T1+T1</code>, <code>K3+T2+T1</code>, <code>K4+T1+T1</code>, <code>K5+T1</code>, <code>NonSimple-7</code>, <code>T1+T1+T1+T1+T1+T1</code>, <code>T2+T1+T1+T1+T1</code>, <code>T2+T2+T1+T1</code>, <code>T3+T1+T1+T1</code>, <code>T3+T2+T1</code>, <code>T4+T1+T1</code>, <code>T5+T1</code>, <code>Y11+T1+T1</code>, <code>Y21+T1</code>.

Invariant cubic basis (36 monomials):

```text
x1^3, x1^2*x2, x1^2*x3, x1^2*x5, x1^2*x6, x1*x2^2, x1*x2*x3, x1*x2*x5, x1*x2*x6, x1*x3^2, x1*x3*x5, x1*x3*x6, x1*x5^2, x1*x5*x6, x1*x6^2, x2^3, x2^2*x3, x2^2*x5, x2^2*x6, x2*x3^2, x2*x3*x5, x2*x3*x6, x2*x5^2, x2*x5*x6, x2*x6^2, x3^3, x3^2*x5, x3^2*x6, x3*x5^2, x3*x5*x6, x3*x6^2, x4^3, x5^3, x5^2*x6, x5*x6^2, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-008` — `C2`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">6</td>
      <td style="white-space:nowrap;"><code>[6,2]</code></td>
      <td><code>C6</code></td>
      <td><code>[ 2, 3 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">2</td>
      <td style="white-space:nowrap;"><code>[2,1]</code></td>
      <td><code>C2</code></td>
      <td><code>[ 2 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **28**, centralizer in \(\mathrm{GL}_6\) **18**, family **10**.
- Determinant-one subgroup order: **3**.
- Sources merged: **11**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>NonSimple-1</code>, <code>NonSimple-3</code>, <code>NonSimple-5</code>, <code>NonSimple-6</code>, <code>NonSimple-8</code>, <code>T2+T2+T2</code>, <code>Y11+T2</code>.

Invariant cubic basis (28 monomials):

```text
x1^2*x2, x1^2*x3, x1^2*x6, x1*x2*x4, x1*x2*x5, x1*x3*x4, x1*x3*x5, x1*x4*x6, x1*x5*x6, x2^3, x2^2*x3, x2^2*x6, x2*x3^2, x2*x3*x6, x2*x4^2, x2*x4*x5, x2*x5^2, x2*x6^2, x3^3, x3^2*x6, x3*x4^2, x3*x4*x5, x3*x5^2, x3*x6^2, x4^2*x6, x4*x5*x6, x5^2*x6, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, -1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-009` — `C2 x C2`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">12</td>
      <td style="white-space:nowrap;"><code>[12,5]</code></td>
      <td><code>C6 x C2</code></td>
      <td><code>[ 2, 2, 3 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">4</td>
      <td style="white-space:nowrap;"><code>[4,2]</code></td>
      <td><code>C2 x C2</code></td>
      <td><code>[ 2, 2 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **22**, centralizer in \(\mathrm{GL}_6\) **14**, family **8**.
- Determinant-one subgroup order: **6**.
- Sources merged: **8**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>NonSimple-3</code>, <code>NonSimple-8</code>, <code>T2+T2+T2</code>, <code>Y11+T2</code>.

Invariant cubic basis (22 monomials):

```text
x1^2*x2, x1^2*x3, x1^2*x6, x2^3, x2^2*x3, x2^2*x6, x2*x3^2, x2*x3*x6, x2*x4^2, x2*x4*x5, x2*x5^2, x2*x6^2, x3^3, x3^2*x6, x3*x4^2, x3*x4*x5, x3*x5^2, x3*x6^2, x4^2*x6, x4*x5*x6, x5^2*x6, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ], [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], 
      [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, -1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-010` — `C2 x C2`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">12</td>
      <td style="white-space:nowrap;"><code>[12,5]</code></td>
      <td><code>C6 x C2</code></td>
      <td><code>[ 2, 2, 3 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">4</td>
      <td style="white-space:nowrap;"><code>[4,2]</code></td>
      <td><code>C2 x C2</code></td>
      <td><code>[ 2, 2 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **20**, centralizer in \(\mathrm{GL}_6\) **12**, family **8**.
- Determinant-one subgroup order: **12**.
- Sources merged: **4**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>NonSimple-4</code>, <code>NonSimple-7</code>, <code>NonSimple-8</code>, <code>T2+T2+T2</code>.

Invariant cubic basis (20 monomials):

```text
x1^2*x2, x1^2*x3, x1^2*x6, x1*x4*x5, x2^3, x2^2*x3, x2^2*x6, x2*x3^2, x2*x3*x6, x2*x4^2, x2*x5^2, x2*x6^2, x3^3, x3^2*x6, x3*x4^2, x3*x5^2, x3*x6^2, x4^2*x6, x5^2*x6, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ], [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], 
      [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, -1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-011` — `C3`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">9</td>
      <td style="white-space:nowrap;"><code>[9,2]</code></td>
      <td><code>C3 x C3</code></td>
      <td><code>[ 3, 3 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">3</td>
      <td style="white-space:nowrap;"><code>[3,1]</code></td>
      <td><code>C3</code></td>
      <td><code>[ 3 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **20**, centralizer in \(\mathrm{GL}_6\) **12**, family **8**.
- Determinant-one subgroup order: **9**.
- Sources merged: **20**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>T1+T1+T1+T1+T1+T1</code>, <code>T2+T1+T1+T1+T1</code>, <code>T2+T2+T1+T1</code>, <code>T2+T2+T2</code>.

Invariant cubic basis (20 monomials):

```text
x1^3, x1^2*x2, x1*x2^2, x1*x3*x4, x1*x3*x6, x1*x4*x5, x1*x5*x6, x2^3, x2*x3*x4, x2*x3*x6, x2*x4*x5, x2*x5*x6, x3^3, x3^2*x5, x3*x5^2, x4^3, x4^2*x6, x4*x6^2, x5^3, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ E(3)^2, 0, 0, 0, 0, 0 ], [ 0, E(3)^2, 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-012` — `C2 x C2 x C2`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">24</td>
      <td style="white-space:nowrap;"><code>[24,15]</code></td>
      <td><code>C6 x C2 x C2</code></td>
      <td><code>[ 2, 2, 2, 3 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">8</td>
      <td style="white-space:nowrap;"><code>[8,5]</code></td>
      <td><code>C2 x C2 x C2</code></td>
      <td><code>[ 2, 2, 2 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **19**, centralizer in \(\mathrm{GL}_6\) **12**, family **7**.
- Determinant-one subgroup order: **12**.
- Sources merged: **1**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>T2+T2+T2</code>.

Invariant cubic basis (19 monomials):

```text
x1^2*x2, x1^2*x4, x1^2*x6, x2^3, x2^2*x4, x2^2*x6, x2*x3^2, x2*x4^2, x2*x4*x6, x2*x5^2, x2*x6^2, x3^2*x4, x3^2*x6, x4^3, x4^2*x6, x4*x5^2, x4*x6^2, x5^2*x6, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, -1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ], [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], 
      [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ], 
  [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-013` — `C6`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">18</td>
      <td style="white-space:nowrap;"><code>[18,5]</code></td>
      <td><code>C6 x C3</code></td>
      <td><code>[ 2, 3, 3 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">6</td>
      <td style="white-space:nowrap;"><code>[6,2]</code></td>
      <td><code>C6</code></td>
      <td><code>[ 2, 3 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **25**, centralizer in \(\mathrm{GL}_6\) **18**, family **7**.
- Determinant-one subgroup order: **3**.
- Sources merged: **18**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>K3+T2+T1</code>, <code>T2+T1+T1+T1+T1</code>, <code>T2+T2+T1+T1</code>, <code>T3+T1+T1+T1</code>, <code>T3+T2+T1</code>, <code>T4+T1+T1</code>, <code>T5+T1</code>, <code>Y21+T1</code>.

Invariant cubic basis (25 monomials):

```text
x1^2*x2, x1^2*x3, x1^2*x4, x1^2*x6, x2^3, x2^2*x3, x2^2*x4, x2^2*x6, x2*x3^2, x2*x3*x4, x2*x3*x6, x2*x4^2, x2*x4*x6, x2*x6^2, x3^3, x3^2*x4, x3^2*x6, x3*x4^2, x3*x4*x6, x3*x6^2, x4^3, x4^2*x6, x4*x6^2, x5^3, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ E(3)^2, 0, 0, 0, 0, 0 ], [ 0, E(3)^2, 0, 0, 0, 0 ], [ 0, 0, E(3)^2, 0, 0, 0 ], [ 0, 0, 0, E(3)^2, 0, 0 ], 
      [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, E(3)^2 ] ], 
  [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-014` — `C4`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">12</td>
      <td style="white-space:nowrap;"><code>[12,2]</code></td>
      <td><code>C12</code></td>
      <td><code>[ 3, 4 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">4</td>
      <td style="white-space:nowrap;"><code>[4,1]</code></td>
      <td><code>C4</code></td>
      <td><code>[ 4 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **25**, centralizer in \(\mathrm{GL}_6\) **18**, family **7**.
- Determinant-one subgroup order: **3**.
- Sources merged: **10**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>K3+T3</code>, <code>T3+T1+T1+T1</code>, <code>T3+T2+T1</code>, <code>T3+T3</code>, <code>T4+T1+T1</code>, <code>T4+T2</code>, <code>T5+T1</code>, <code>T6</code>, <code>Y31</code>.

Invariant cubic basis (25 monomials):

```text
x1^2*x2, x2^2*x3, x2^2*x4, x2^2*x5, x2^2*x6, x3^3, x3^2*x4, x3^2*x5, x3^2*x6, x3*x4^2, x3*x4*x5, x3*x4*x6, x3*x5^2, x3*x5*x6, x3*x6^2, x4^3, x4^2*x5, x4^2*x6, x4*x5^2, x4*x5*x6, x4*x6^2, x5^3, x5^2*x6, x5*x6^2, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ -E(4), 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ],
      [ 0, 0, 0, 0, 0, 1 ] ], [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], 
      [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-015` — `C4`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">12</td>
      <td style="white-space:nowrap;"><code>[12,2]</code></td>
      <td><code>C12</code></td>
      <td><code>[ 3, 4 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">4</td>
      <td style="white-space:nowrap;"><code>[4,1]</code></td>
      <td><code>C4</code></td>
      <td><code>[ 4 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **21**, centralizer in \(\mathrm{GL}_6\) **14**, family **7**.
- Determinant-one subgroup order: **3**.
- Sources merged: **7**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>NonSimple-3</code>, <code>T3+T2+T1</code>, <code>T3+T3</code>, <code>T4+T2</code>, <code>Y21+T1</code>.

Invariant cubic basis (21 monomials):

```text
x1^2*x2, x1^2*x4, x2^2*x3, x2^2*x5, x2^2*x6, x2*x3*x4, x2*x4*x5, x2*x4*x6, x3^3, x3^2*x5, x3^2*x6, x3*x4^2, x3*x5^2, x3*x5*x6, x3*x6^2, x4^2*x5, x4^2*x6, x5^3, x5^2*x6, x5*x6^2, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ], [ [ E(4), 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], 
      [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-016` — `C3`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">9</td>
      <td style="white-space:nowrap;"><code>[9,2]</code></td>
      <td><code>C3 x C3</code></td>
      <td><code>[ 3, 3 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">3</td>
      <td style="white-space:nowrap;"><code>[3,1]</code></td>
      <td><code>C3</code></td>
      <td><code>[ 3 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **21**, centralizer in \(\mathrm{GL}_6\) **14**, family **7**.
- Determinant-one subgroup order: **3**.
- Sources merged: **88**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>K3+T1+T1+T1</code>, <code>K3+T2+T1</code>, <code>T1+T1+T1+T1+T1+T1</code>, <code>T2+T1+T1+T1+T1</code>, <code>T2+T2+T1+T1</code>, <code>T3+T1+T1+T1</code>, <code>T3+T2+T1</code>.

Invariant cubic basis (21 monomials):

```text
x1^3, x1^2*x3, x1^2*x5, x1*x2*x4, x1*x3^2, x1*x3*x5, x1*x4*x6, x1*x5^2, x2^3, x2^2*x6, x2*x3*x4, x2*x4*x5, x2*x6^2, x3^3, x3^2*x5, x3*x4*x6, x3*x5^2, x4^3, x4*x5*x6, x5^3, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ 1, 0, 0, 0, 0, 0 ], [ 0, E(3)^2, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, E(3)^2 ] ] ]
```

</details>

### `LA-017` — `C6`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">18</td>
      <td style="white-space:nowrap;"><code>[18,5]</code></td>
      <td><code>C6 x C3</code></td>
      <td><code>[ 2, 3, 3 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">6</td>
      <td style="white-space:nowrap;"><code>[6,2]</code></td>
      <td><code>C6</code></td>
      <td><code>[ 2, 3 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **20**, centralizer in \(\mathrm{GL}_6\) **14**, family **6**.
- Determinant-one subgroup order: **6**.
- Sources merged: **11**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>NonSimple-7</code>, <code>T2+T2+T1+T1</code>, <code>T3+T2+T1</code>, <code>Y11+T1+T1</code>.

Invariant cubic basis (20 monomials):

```text
x1^2*x2, x1^2*x4, x1^2*x5, x1*x2*x3, x1*x3*x4, x1*x3*x5, x2^3, x2^2*x4, x2^2*x5, x2*x3^2, x2*x4^2, x2*x4*x5, x2*x5^2, x3^2*x4, x3^2*x5, x4^3, x4^2*x5, x4*x5^2, x5^3, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, E(3) ] ], [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], 
      [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-018` — `C4`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">12</td>
      <td style="white-space:nowrap;"><code>[12,2]</code></td>
      <td><code>C12</code></td>
      <td><code>[ 3, 4 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">4</td>
      <td style="white-space:nowrap;"><code>[4,1]</code></td>
      <td><code>C4</code></td>
      <td><code>[ 4 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **16**, centralizer in \(\mathrm{GL}_6\) **10**, family **6**.
- Determinant-one subgroup order: **12**.
- Sources merged: **5**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>NonSimple-5</code>, <code>NonSimple-6</code>, <code>T3+T3</code>, <code>Y11+T2</code>, <code>Y22</code>.

Invariant cubic basis (16 monomials):

```text
x1^2*x2, x1^2*x5, x1*x3*x4, x1*x4*x6, x2^2*x3, x2^2*x6, x2*x3*x5, x2*x4^2, x2*x5*x6, x3^3, x3^2*x6, x3*x5^2, x3*x6^2, x4^2*x5, x5^2*x6, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ E(4), 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -E(4), 0, 0 ], 
      [ 0, 0, 0, 0, -1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ], 
  [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-019` — `C2 x C2`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">12</td>
      <td style="white-space:nowrap;"><code>[12,5]</code></td>
      <td><code>C6 x C2</code></td>
      <td><code>[ 2, 2, 3 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">4</td>
      <td style="white-space:nowrap;"><code>[4,2]</code></td>
      <td><code>C2 x C2</code></td>
      <td><code>[ 2, 2 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **16**, centralizer in \(\mathrm{GL}_6\) **10**, family **6**.
- Determinant-one subgroup order: **6**.
- Sources merged: **5**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>NonSimple-5</code>, <code>NonSimple-6</code>, <code>NonSimple-8</code>.

Invariant cubic basis (16 monomials):

```text
x1^2*x2, x1^2*x3, x1*x4*x5, x1*x4*x6, x2^3, x2^2*x3, x2*x3^2, x2*x4^2, x2*x5^2, x2*x5*x6, x2*x6^2, x3^3, x3*x4^2, x3*x5^2, x3*x5*x6, x3*x6^2
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ], [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], 
      [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, -1, 0 ], [ 0, 0, 0, 0, 0, -1 ] ] ]
```

</details>

### `LA-020` — `C3`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">9</td>
      <td style="white-space:nowrap;"><code>[9,1]</code></td>
      <td><code>C9</code></td>
      <td><code>[ 9 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">3</td>
      <td style="white-space:nowrap;"><code>[3,1]</code></td>
      <td><code>C3</code></td>
      <td><code>[ 3 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **18**, centralizer in \(\mathrm{GL}_6\) **12**, family **6**.
- Determinant-one subgroup order: **3**.
- Sources merged: **5**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>K3+K3</code>, <code>K6</code>, <code>NonSimple-1</code>.

Invariant cubic basis (18 monomials):

```text
x1^2*x2, x1^2*x4, x1*x2*x6, x1*x3^2, x1*x3*x5, x1*x4*x6, x1*x5^2, x2^2*x3, x2^2*x5, x2*x3*x4, x2*x4*x5, x2*x6^2, x3^2*x6, x3*x4^2, x3*x5*x6, x4^2*x5, x4*x6^2, x5^2*x6
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ E(9)^4, 0, 0, 0, 0, 0 ], [ 0, -E(9)^4-E(9)^7, 0, 0, 0, 0 ], [ 0, 0, E(9)^7, 0, 0, 0 ], 
      [ 0, 0, 0, -E(9)^4-E(9)^7, 0, 0 ], [ 0, 0, 0, 0, E(9)^7, 0 ], [ 0, 0, 0, 0, 0, E(9)^4 ] ] ]
```

</details>

### `LA-021` — `C6 x C2`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">36</td>
      <td style="white-space:nowrap;"><code>[36,14]</code></td>
      <td><code>C6 x C6</code></td>
      <td><code>[ 2, 2, 3, 3 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">12</td>
      <td style="white-space:nowrap;"><code>[12,5]</code></td>
      <td><code>C6 x C2</code></td>
      <td><code>[ 2, 2, 3 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **17**, centralizer in \(\mathrm{GL}_6\) **12**, family **5**.
- Determinant-one subgroup order: **6**.
- Sources merged: **3**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>T2+T2+T1+T1</code>, <code>T3+T2+T1</code>.

Invariant cubic basis (17 monomials):

```text
x1^2*x2, x1^2*x3, x1^2*x5, x2^3, x2^2*x3, x2^2*x5, x2*x3^2, x2*x3*x5, x2*x4^2, x2*x5^2, x3^3, x3^2*x5, x3*x4^2, x3*x5^2, x4^2*x5, x5^3, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ], [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], 
      [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, 1 ] ], 
  [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-022` — `C4 x C2`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">24</td>
      <td style="white-space:nowrap;"><code>[24,9]</code></td>
      <td><code>C12 x C2</code></td>
      <td><code>[ 2, 3, 4 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">8</td>
      <td style="white-space:nowrap;"><code>[8,2]</code></td>
      <td><code>C4 x C2</code></td>
      <td><code>[ 2, 4 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **17**, centralizer in \(\mathrm{GL}_6\) **12**, family **5**.
- Determinant-one subgroup order: **6**.
- Sources merged: **4**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>T3+T2+T1</code>, <code>T3+T3</code>, <code>T4+T2</code>.

Invariant cubic basis (17 monomials):

```text
x1^2*x2, x2^2*x3, x2^2*x5, x2^2*x6, x3^3, x3^2*x5, x3^2*x6, x3*x4^2, x3*x5^2, x3*x5*x6, x3*x6^2, x4^2*x5, x4^2*x6, x5^3, x5^2*x6, x5*x6^2, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ], [ [ -E(4), 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], 
      [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ], 
  [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-023` — `C2 x C2 x C2`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">24</td>
      <td style="white-space:nowrap;"><code>[24,15]</code></td>
      <td><code>C6 x C2 x C2</code></td>
      <td><code>[ 2, 2, 2, 3 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">8</td>
      <td style="white-space:nowrap;"><code>[8,5]</code></td>
      <td><code>C2 x C2 x C2</code></td>
      <td><code>[ 2, 2, 2 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **13**, centralizer in \(\mathrm{GL}_6\) **8**, family **5**.
- Determinant-one subgroup order: **12**.
- Sources merged: **1**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>NonSimple-8</code>.

Invariant cubic basis (13 monomials):

```text
x1^2*x5, x1^2*x6, x1*x2*x3, x2^2*x5, x2^2*x6, x3^2*x5, x3^2*x6, x4^2*x5, x4^2*x6, x5^3, x5^2*x6, x5*x6^2, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ 1, 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ], [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], 
      [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ], 
  [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-024` — `C6`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">18</td>
      <td style="white-space:nowrap;"><code>[18,5]</code></td>
      <td><code>C6 x C3</code></td>
      <td><code>[ 2, 3, 3 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">6</td>
      <td style="white-space:nowrap;"><code>[6,2]</code></td>
      <td><code>C6</code></td>
      <td><code>[ 2, 3 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **15**, centralizer in \(\mathrm{GL}_6\) **10**, family **5**.
- Determinant-one subgroup order: **3**.
- Sources merged: **20**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>T2+T1+T1+T1+T1</code>, <code>T2+T2+T1+T1</code>, <code>T3+T1+T1+T1</code>, <code>T3+T2+T1</code>.

Invariant cubic basis (15 monomials):

```text
x1^2*x2, x1^2*x3, x2^3, x2^2*x3, x2*x3^2, x2*x4*x5, x2*x4*x6, x3^3, x3*x4*x5, x3*x4*x6, x4^3, x5^3, x5^2*x6, x5*x6^2, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], 
      [ 0, 0, 0, 0, E(3)^2, 0 ], [ 0, 0, 0, 0, 0, E(3)^2 ] ], 
  [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-025` — `C6 x C2`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">36</td>
      <td style="white-space:nowrap;"><code>[36,14]</code></td>
      <td><code>C6 x C6</code></td>
      <td><code>[ 2, 2, 3, 3 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">12</td>
      <td style="white-space:nowrap;"><code>[12,5]</code></td>
      <td><code>C6 x C2</code></td>
      <td><code>[ 2, 2, 3 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **12**, centralizer in \(\mathrm{GL}_6\) **8**, family **4**.
- Determinant-one subgroup order: **12**.
- Sources merged: **2**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>NonSimple-7</code>.

Invariant cubic basis (12 monomials):

```text
x1^2*x4, x1^2*x5, x1*x2*x3, x2^2*x4, x2^2*x5, x3^2*x4, x3^2*x5, x4^3, x4^2*x5, x4*x5^2, x5^3, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ 1, 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ], [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], 
      [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ], 
  [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, E(3) ] ] ]
```

</details>

### `LA-026` — `C3 x C3`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">27</td>
      <td style="white-space:nowrap;"><code>[27,5]</code></td>
      <td><code>C3 x C3 x C3</code></td>
      <td><code>[ 3, 3, 3 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">9</td>
      <td style="white-space:nowrap;"><code>[9,2]</code></td>
      <td><code>C3 x C3</code></td>
      <td><code>[ 3, 3 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **14**, centralizer in \(\mathrm{GL}_6\) **10**, family **4**.
- Determinant-one subgroup order: **9**.
- Sources merged: **104**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>T1+T1+T1+T1+T1+T1</code>, <code>T2+T1+T1+T1+T1</code>, <code>T2+T2+T1+T1</code>.

Invariant cubic basis (14 monomials):

```text
x1^3, x2^3, x2^2*x5, x2*x3*x4, x2*x3*x6, x2*x5^2, x3^3, x3*x4*x5, x3*x5*x6, x4^3, x4^2*x6, x4*x6^2, x5^3, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ 1, 0, 0, 0, 0, 0 ], [ 0, E(3)^2, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3)^2, 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-027` — `C4 x C2`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">24</td>
      <td style="white-space:nowrap;"><code>[24,9]</code></td>
      <td><code>C12 x C2</code></td>
      <td><code>[ 2, 3, 4 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">8</td>
      <td style="white-space:nowrap;"><code>[8,2]</code></td>
      <td><code>C4 x C2</code></td>
      <td><code>[ 2, 4 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **12**, centralizer in \(\mathrm{GL}_6\) **8**, family **4**.
- Determinant-one subgroup order: **6**.
- Sources merged: **1**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>NonSimple-3</code>.

Invariant cubic basis (12 monomials):

```text
x1^2*x2, x2^2*x3, x2^2*x6, x2*x4*x5, x3^3, x3^2*x6, x3*x4^2, x3*x5^2, x3*x6^2, x4^2*x6, x5^2*x6, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ], [ [ E(4), 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], 
      [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, -1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ], 
  [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, -1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-028` — `C4 x C2`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">24</td>
      <td style="white-space:nowrap;"><code>[24,9]</code></td>
      <td><code>C12 x C2</code></td>
      <td><code>[ 2, 3, 4 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">8</td>
      <td style="white-space:nowrap;"><code>[8,2]</code></td>
      <td><code>C4 x C2</code></td>
      <td><code>[ 2, 4 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **14**, centralizer in \(\mathrm{GL}_6\) **10**, family **4**.
- Determinant-one subgroup order: **12**.
- Sources merged: **2**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>T3+T3</code>, <code>Y22</code>.

Invariant cubic basis (14 monomials):

```text
x1^2*x2, x1^2*x5, x2^2*x3, x2^2*x6, x2*x3*x5, x2*x4^2, x2*x5*x6, x3^3, x3^2*x6, x3*x5^2, x3*x6^2, x4^2*x5, x5^2*x6, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ -E(4), 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -E(4), 0, 0 ], 
      [ 0, 0, 0, 0, -1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ], 
  [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ], [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], 
      [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-029` — `C6`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">18</td>
      <td style="white-space:nowrap;"><code>[18,5]</code></td>
      <td><code>C6 x C3</code></td>
      <td><code>[ 2, 3, 3 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">6</td>
      <td style="white-space:nowrap;"><code>[6,2]</code></td>
      <td><code>C6</code></td>
      <td><code>[ 2, 3 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **16**, centralizer in \(\mathrm{GL}_6\) **12**, family **4**.
- Determinant-one subgroup order: **3**.
- Sources merged: **10**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>K3+T2+T1</code>, <code>T2+T1+T1+T1+T1</code>, <code>T2+T2+T1+T1</code>, <code>T3+T2+T1</code>.

Invariant cubic basis (16 monomials):

```text
x1^2*x2, x2^3, x2*x3*x5, x2*x4*x5, x2*x5*x6, x3^3, x3^2*x4, x3^2*x6, x3*x4^2, x3*x4*x6, x3*x6^2, x4^3, x4^2*x6, x4*x6^2, x5^3, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3)^2, 0, 0, 0 ], [ 0, 0, 0, E(3)^2, 0, 0 ], 
      [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, E(3)^2 ] ], 
  [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-030` — `C6`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">18</td>
      <td style="white-space:nowrap;"><code>[18,5]</code></td>
      <td><code>C6 x C3</code></td>
      <td><code>[ 2, 3, 3 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">6</td>
      <td style="white-space:nowrap;"><code>[6,2]</code></td>
      <td><code>C6</code></td>
      <td><code>[ 2, 3 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **14**, centralizer in \(\mathrm{GL}_6\) **10**, family **4**.
- Determinant-one subgroup order: **9**.
- Sources merged: **8**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>T2+T1+T1+T1+T1</code>, <code>T2+T2+T1+T1</code>, <code>T2+T2+T2</code>.

Invariant cubic basis (14 monomials):

```text
x1^2*x2, x2^3, x2*x3*x4, x2*x3*x5, x2*x4*x6, x2*x5*x6, x3^3, x3^2*x6, x3*x6^2, x4^3, x4^2*x5, x4*x5^2, x5^3, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3)^2, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], 
      [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, E(3)^2 ] ], 
  [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-031` — `C6`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">18</td>
      <td style="white-space:nowrap;"><code>[18,5]</code></td>
      <td><code>C6 x C3</code></td>
      <td><code>[ 2, 3, 3 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">6</td>
      <td style="white-space:nowrap;"><code>[6,2]</code></td>
      <td><code>C6</code></td>
      <td><code>[ 2, 3 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **12**, centralizer in \(\mathrm{GL}_6\) **8**, family **4**.
- Determinant-one subgroup order: **6**.
- Sources merged: **5**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>T2+T2+T1+T1</code>, <code>T3+T2+T1</code>.

Invariant cubic basis (12 monomials):

```text
x1^2*x2, x1^2*x5, x1*x3*x6, x2^3, x2^2*x5, x2*x4*x6, x2*x5^2, x3^2*x4, x4^3, x4*x5*x6, x5^3, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, E(3)^2 ] ], 
  [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-032` — `C6`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">18</td>
      <td style="white-space:nowrap;"><code>[18,5]</code></td>
      <td><code>C6 x C3</code></td>
      <td><code>[ 2, 3, 3 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">6</td>
      <td style="white-space:nowrap;"><code>[6,2]</code></td>
      <td><code>C6</code></td>
      <td><code>[ 2, 3 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **10**, centralizer in \(\mathrm{GL}_6\) **6**, family **4**.
- Determinant-one subgroup order: **9**.
- Sources merged: **1**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>T2+T2+T2</code>.

Invariant cubic basis (10 monomials):

```text
x1^2*x2, x1*x3*x6, x1*x4*x5, x2^3, x2*x3*x5, x2*x4*x6, x3^2*x4, x4^3, x5^2*x6, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, -1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ], [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], 
      [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, E(3)^2, 0 ], [ 0, 0, 0, 0, 0, E(3)^2 ] ] ]
```

</details>

### `LA-033` — `C4`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">12</td>
      <td style="white-space:nowrap;"><code>[12,2]</code></td>
      <td><code>C12</code></td>
      <td><code>[ 3, 4 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">4</td>
      <td style="white-space:nowrap;"><code>[4,1]</code></td>
      <td><code>C4</code></td>
      <td><code>[ 4 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **16**, centralizer in \(\mathrm{GL}_6\) **12**, family **4**.
- Determinant-one subgroup order: **6**.
- Sources merged: **4**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>NonSimple-2</code>, <code>NonSimple-4</code>, <code>NonSimple-5</code>, <code>NonSimple-6</code>.

Invariant cubic basis (16 monomials):

```text
x1^2*x2, x1^2*x5, x1*x2*x4, x1*x4*x5, x2^2*x3, x2^2*x6, x2*x3*x5, x2*x4^2, x2*x5*x6, x3^3, x3^2*x6, x3*x5^2, x3*x6^2, x4^2*x5, x5^2*x6, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ], [ [ E(4), 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], 
      [ 0, 0, 0, E(4), 0, 0 ], [ 0, 0, 0, 0, -1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-034` — `C12`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">36</td>
      <td style="white-space:nowrap;"><code>[36,8]</code></td>
      <td><code>C12 x C3</code></td>
      <td><code>[ 3, 3, 4 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">12</td>
      <td style="white-space:nowrap;"><code>[12,2]</code></td>
      <td><code>C12</code></td>
      <td><code>[ 3, 4 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **15**, centralizer in \(\mathrm{GL}_6\) **12**, family **3**.
- Determinant-one subgroup order: **3**.
- Sources merged: **7**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>T3+T1+T1+T1</code>, <code>T3+T2+T1</code>, <code>T4+T1+T1</code>, <code>T5+T1</code>.

Invariant cubic basis (15 monomials):

```text
x1^2*x2, x2^2*x3, x2^2*x4, x2^2*x5, x3^3, x3^2*x4, x3^2*x5, x3*x4^2, x3*x4*x5, x3*x5^2, x4^3, x4^2*x5, x4*x5^2, x5^3, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, 1 ] ], 
  [ [ -E(4), 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ],
      [ 0, 0, 0, 0, 0, 1 ] ], [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], 
      [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-035` — `C12`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">36</td>
      <td style="white-space:nowrap;"><code>[36,8]</code></td>
      <td><code>C12 x C3</code></td>
      <td><code>[ 3, 3, 4 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">12</td>
      <td style="white-space:nowrap;"><code>[12,2]</code></td>
      <td><code>C12</code></td>
      <td><code>[ 3, 4 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **13**, centralizer in \(\mathrm{GL}_6\) **10**, family **3**.
- Determinant-one subgroup order: **3**.
- Sources merged: **2**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>T3+T2+T1</code>, <code>Y21+T1</code>.

Invariant cubic basis (13 monomials):

```text
x1^2*x2, x1^2*x4, x2^2*x3, x2^2*x5, x2*x3*x4, x2*x4*x5, x3^3, x3^2*x5, x3*x4^2, x3*x5^2, x4^2*x5, x5^3, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ -E(4), 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], 
      [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ], 
  [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, 1 ] ], 
  [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-036` — `C6 x C2`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">36</td>
      <td style="white-space:nowrap;"><code>[36,14]</code></td>
      <td><code>C6 x C6</code></td>
      <td><code>[ 2, 2, 3, 3 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">12</td>
      <td style="white-space:nowrap;"><code>[12,5]</code></td>
      <td><code>C6 x C2</code></td>
      <td><code>[ 2, 2, 3 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **11**, centralizer in \(\mathrm{GL}_6\) **8**, family **3**.
- Determinant-one subgroup order: **6**.
- Sources merged: **5**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>T2+T2+T1+T1</code>, <code>T3+T2+T1</code>.

Invariant cubic basis (11 monomials):

```text
x1^2*x2, x1^2*x3, x2^3, x2^2*x3, x2*x3^2, x2*x5*x6, x3^3, x3*x5*x6, x4^2*x5, x5^3, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ], [ [ E(3)^2, 0, 0, 0, 0, 0 ], [ 0, E(3)^2, 0, 0, 0, 0 ], [ 0, 0, E(3)^2, 0, 0, 0 ], 
      [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, 1 ] ], 
  [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-037` — `C3 x C3`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">27</td>
      <td style="white-space:nowrap;"><code>[27,5]</code></td>
      <td><code>C3 x C3 x C3</code></td>
      <td><code>[ 3, 3, 3 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">9</td>
      <td style="white-space:nowrap;"><code>[9,2]</code></td>
      <td><code>C3 x C3</code></td>
      <td><code>[ 3, 3 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **9**, centralizer in \(\mathrm{GL}_6\) **6**, family **3**.
- Determinant-one subgroup order: **9**.
- Sources merged: **120**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>T1+T1+T1+T1+T1+T1</code>.

Invariant cubic basis (9 monomials):

```text
x1^3, x1*x2*x5, x2^3, x2*x3*x4, x3^3, x3*x5*x6, x4^3, x5^3, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ 1, 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, E(3)^2, 0, 0 ], 
      [ 0, 0, 0, 0, E(3)^2, 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3)^2, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-038` — `C8`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">24</td>
      <td style="white-space:nowrap;"><code>[24,2]</code></td>
      <td><code>C24</code></td>
      <td><code>[ 3, 8 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">8</td>
      <td style="white-space:nowrap;"><code>[8,1]</code></td>
      <td><code>C8</code></td>
      <td><code>[ 8 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **15**, centralizer in \(\mathrm{GL}_6\) **12**, family **3**.
- Determinant-one subgroup order: **3**.
- Sources merged: **4**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>T4+T1+T1</code>, <code>T4+T2</code>, <code>T5+T1</code>, <code>T6</code>.

Invariant cubic basis (15 monomials):

```text
x1^2*x2, x2^2*x3, x3^2*x4, x3^2*x5, x3^2*x6, x4^3, x4^2*x5, x4^2*x6, x4*x5^2, x4*x5*x6, x4*x6^2, x5^3, x5^2*x6, x5*x6^2, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ E(8)^3, 0, 0, 0, 0, 0 ], [ 0, E(4), 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], 
      [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ], 
  [ [ -E(4), 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ],
      [ 0, 0, 0, 0, 0, 1 ] ], [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], 
      [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-039` — `C8`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">24</td>
      <td style="white-space:nowrap;"><code>[24,2]</code></td>
      <td><code>C24</code></td>
      <td><code>[ 3, 8 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">8</td>
      <td style="white-space:nowrap;"><code>[8,1]</code></td>
      <td><code>C8</code></td>
      <td><code>[ 8 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **13**, centralizer in \(\mathrm{GL}_6\) **10**, family **3**.
- Determinant-one subgroup order: **3**.
- Sources merged: **2**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>T4+T2</code>, <code>Y31</code>.

Invariant cubic basis (13 monomials):

```text
x1^2*x2, x2^2*x3, x2^2*x4, x3^2*x5, x3^2*x6, x3*x4*x5, x3*x4*x6, x4^2*x5, x4^2*x6, x5^3, x5^2*x6, x5*x6^2, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ], [ [ E(4), 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], 
      [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ], 
  [ [ E(8), 0, 0, 0, 0, 0 ], [ 0, -E(4), 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], 
      [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-040` — `C8`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">24</td>
      <td style="white-space:nowrap;"><code>[24,2]</code></td>
      <td><code>C24</code></td>
      <td><code>[ 3, 8 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">8</td>
      <td style="white-space:nowrap;"><code>[8,1]</code></td>
      <td><code>C8</code></td>
      <td><code>[ 8 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **11**, centralizer in \(\mathrm{GL}_6\) **8**, family **3**.
- Determinant-one subgroup order: **3**.
- Sources merged: **1**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>Y21+T1</code>.

Invariant cubic basis (11 monomials):

```text
x1^2*x2, x2^2*x4, x2*x3*x5, x2*x3*x6, x3^2*x4, x4^2*x5, x4^2*x6, x5^3, x5^2*x6, x5*x6^2, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ -E(8)^3, 0, 0, 0, 0, 0 ], [ 0, E(4), 0, 0, 0, 0 ], [ 0, 0, -E(4), 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], 
      [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ], 
  [ [ -E(4), 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], 
      [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ], 
  [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-041` — `C6`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">18</td>
      <td style="white-space:nowrap;"><code>[18,2]</code></td>
      <td><code>C18</code></td>
      <td><code>[ 2, 9 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">6</td>
      <td style="white-space:nowrap;"><code>[6,2]</code></td>
      <td><code>C6</code></td>
      <td><code>[ 2, 3 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **9**, centralizer in \(\mathrm{GL}_6\) **6**, family **3**.
- Determinant-one subgroup order: **3**.
- Sources merged: **1**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>NonSimple-1</code>.

Invariant cubic basis (9 monomials):

```text
x1^2*x2, x1*x3^2, x1*x4^2, x1*x5*x6, x2^2*x3, x2*x4*x6, x2*x5^2, x3*x4*x5, x3*x6^2
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ E(9)^2, 0, 0, 0, 0, 0 ], [ 0, E(9)^5, 0, 0, 0, 0 ], [ 0, 0, -E(9)^2-E(9)^5, 0, 0, 0 ], 
      [ 0, 0, 0, -E(9)^2-E(9)^5, 0, 0 ], [ 0, 0, 0, 0, E(9)^2, 0 ], [ 0, 0, 0, 0, 0, E(9)^5 ] ], 
  [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, -1, 0 ], 
      [ 0, 0, 0, 0, 0, -1 ] ] ]
```

</details>

### `LA-042` — `C12 x C2`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">72</td>
      <td style="white-space:nowrap;"><code>[72,36]</code></td>
      <td><code>C12 x C6</code></td>
      <td><code>[ 2, 3, 3, 4 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">24</td>
      <td style="white-space:nowrap;"><code>[24,9]</code></td>
      <td><code>C12 x C2</code></td>
      <td><code>[ 2, 3, 4 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **10**, centralizer in \(\mathrm{GL}_6\) **8**, family **2**.
- Determinant-one subgroup order: **6**.
- Sources merged: **1**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>T3+T2+T1</code>.

Invariant cubic basis (10 monomials):

```text
x1^2*x2, x2^2*x3, x2^2*x5, x3^3, x3^2*x5, x3*x4^2, x3*x5^2, x4^2*x5, x5^3, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ], [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], 
      [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, 1 ] ], 
  [ [ -E(4), 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ],
      [ 0, 0, 0, 0, 0, 1 ] ], [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], 
      [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-043` — `C6 x C3`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">54</td>
      <td style="white-space:nowrap;"><code>[54,15]</code></td>
      <td><code>C6 x C3 x C3</code></td>
      <td><code>[ 2, 3, 3, 3 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">18</td>
      <td style="white-space:nowrap;"><code>[18,5]</code></td>
      <td><code>C6 x C3</code></td>
      <td><code>[ 2, 3, 3 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **10**, centralizer in \(\mathrm{GL}_6\) **8**, family **2**.
- Determinant-one subgroup order: **9**.
- Sources merged: **16**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>T2+T1+T1+T1+T1</code>, <code>T2+T2+T1+T1</code>.

Invariant cubic basis (10 monomials):

```text
x1^2*x2, x2^3, x2*x3*x5, x2*x4*x5, x3^3, x3^2*x4, x3*x4^2, x4^3, x5^3, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, E(3)^2 ] ], [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], 
      [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, E(3)^2, 0 ], [ 0, 0, 0, 0, 0, E(3)^2 ] ], 
  [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-044` — `C4 x C4`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">48</td>
      <td style="white-space:nowrap;"><code>[48,20]</code></td>
      <td><code>C12 x C4</code></td>
      <td><code>[ 3, 4, 4 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">16</td>
      <td style="white-space:nowrap;"><code>[16,2]</code></td>
      <td><code>C4 x C4</code></td>
      <td><code>[ 4, 4 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **10**, centralizer in \(\mathrm{GL}_6\) **8**, family **2**.
- Determinant-one subgroup order: **12**.
- Sources merged: **1**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>T3+T3</code>.

Invariant cubic basis (10 monomials):

```text
x1^2*x2, x2^2*x3, x2^2*x6, x3^3, x3^2*x6, x3*x5^2, x3*x6^2, x4^2*x5, x5^2*x6, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -E(4), 0, 0 ], [ 0, 0, 0, 0, -1, 0 ],
      [ 0, 0, 0, 0, 0, 1 ] ], [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], 
      [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ], 
  [ [ -E(4), 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ],
      [ 0, 0, 0, 0, 0, 1 ] ], [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], 
      [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-045` — `C8 x C2`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">48</td>
      <td style="white-space:nowrap;"><code>[48,23]</code></td>
      <td><code>C24 x C2</code></td>
      <td><code>[ 2, 3, 8 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">16</td>
      <td style="white-space:nowrap;"><code>[16,5]</code></td>
      <td><code>C8 x C2</code></td>
      <td><code>[ 2, 8 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **10**, centralizer in \(\mathrm{GL}_6\) **8**, family **2**.
- Determinant-one subgroup order: **6**.
- Sources merged: **1**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>T4+T2</code>.

Invariant cubic basis (10 monomials):

```text
x1^2*x2, x2^2*x3, x3^2*x4, x3^2*x6, x4^3, x4^2*x6, x4*x5^2, x4*x6^2, x5^2*x6, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, -1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ], [ [ E(8)^3, 0, 0, 0, 0, 0 ], [ 0, E(4), 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], 
      [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ], 
  [ [ -E(4), 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ],
      [ 0, 0, 0, 0, 0, 1 ] ], [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], 
      [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-046` — `C12`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">36</td>
      <td style="white-space:nowrap;"><code>[36,8]</code></td>
      <td><code>C12 x C3</code></td>
      <td><code>[ 3, 3, 4 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">12</td>
      <td style="white-space:nowrap;"><code>[12,2]</code></td>
      <td><code>C12</code></td>
      <td><code>[ 3, 4 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **10**, centralizer in \(\mathrm{GL}_6\) **8**, family **2**.
- Determinant-one subgroup order: **3**.
- Sources merged: **4**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>T3+T1+T1+T1</code>, <code>T3+T2+T1</code>.

Invariant cubic basis (10 monomials):

```text
x1^2*x2, x2^2*x3, x3^3, x3*x4*x5, x3*x4*x6, x4^3, x5^3, x5^2*x6, x5*x6^2, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ E(3)^2, 0, 0, 0, 0, 0 ], [ 0, E(3)^2, 0, 0, 0, 0 ], [ 0, 0, E(3)^2, 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ], 
  [ [ -E(4), 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ],
      [ 0, 0, 0, 0, 0, 1 ] ], [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], 
      [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-047` — `C12`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">36</td>
      <td style="white-space:nowrap;"><code>[36,8]</code></td>
      <td><code>C12 x C3</code></td>
      <td><code>[ 3, 3, 4 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">12</td>
      <td style="white-space:nowrap;"><code>[12,2]</code></td>
      <td><code>C12</code></td>
      <td><code>[ 3, 4 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **8**, centralizer in \(\mathrm{GL}_6\) **6**, family **2**.
- Determinant-one subgroup order: **3**.
- Sources merged: **1**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>T3+T2+T1</code>.

Invariant cubic basis (8 monomials):

```text
x1^2*x2, x2^2*x3, x2*x4*x6, x3^3, x3*x5*x6, x4^2*x5, x5^3, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ -E(4), 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], 
      [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ], 
  [ [ E(3)^2, 0, 0, 0, 0, 0 ], [ 0, E(3)^2, 0, 0, 0, 0 ], [ 0, 0, E(3)^2, 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, 1 ] ], 
  [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-048` — `C4 x C2`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">24</td>
      <td style="white-space:nowrap;"><code>[24,9]</code></td>
      <td><code>C12 x C2</code></td>
      <td><code>[ 2, 3, 4 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">8</td>
      <td style="white-space:nowrap;"><code>[8,2]</code></td>
      <td><code>C4 x C2</code></td>
      <td><code>[ 2, 4 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **8**, centralizer in \(\mathrm{GL}_6\) **6**, family **2**.
- Determinant-one subgroup order: **12**.
- Sources merged: **2**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>NonSimple-5</code>, <code>NonSimple-6</code>.

Invariant cubic basis (8 monomials):

```text
x1^2*x2, x1*x5*x6, x2^2*x3, x2*x4*x5, x2*x6^2, x3^3, x3*x4^2, x3*x5^2
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, -1 ] ], [ [ E(4), 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], 
      [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, -E(4) ] ], 
  [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, -1, 0 ], 
      [ 0, 0, 0, 0, 0, -1 ] ] ]
```

</details>

### `LA-049` — `C12 x C2`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">72</td>
      <td style="white-space:nowrap;"><code>[72,36]</code></td>
      <td><code>C12 x C6</code></td>
      <td><code>[ 2, 3, 3, 4 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">24</td>
      <td style="white-space:nowrap;"><code>[24,9]</code></td>
      <td><code>C12 x C2</code></td>
      <td><code>[ 2, 3, 4 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **7**, centralizer in \(\mathrm{GL}_6\) **6**, family **1**.
- Determinant-one subgroup order: **6**.
- Sources merged: **1**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>T3+T2+T1</code>.

Invariant cubic basis (7 monomials):

```text
x1^2*x2, x2^2*x3, x3^3, x3*x5*x6, x4^2*x5, x5^3, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ 1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ], [ [ E(3)^2, 0, 0, 0, 0, 0 ], [ 0, E(3)^2, 0, 0, 0, 0 ], [ 0, 0, E(3)^2, 0, 0, 0 ], 
      [ 0, 0, 0, E(3), 0, 0 ], [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, 1 ] ], 
  [ [ -E(4), 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ],
      [ 0, 0, 0, 0, 0, 1 ] ], [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], 
      [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-050` — `C24`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">72</td>
      <td style="white-space:nowrap;"><code>[72,14]</code></td>
      <td><code>C24 x C3</code></td>
      <td><code>[ 3, 3, 8 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">24</td>
      <td style="white-space:nowrap;"><code>[24,2]</code></td>
      <td><code>C24</code></td>
      <td><code>[ 3, 8 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **9**, centralizer in \(\mathrm{GL}_6\) **8**, family **1**.
- Determinant-one subgroup order: **3**.
- Sources merged: **3**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>T4+T1+T1</code>, <code>T5+T1</code>.

Invariant cubic basis (9 monomials):

```text
x1^2*x2, x2^2*x3, x3^2*x4, x3^2*x5, x4^3, x4^2*x5, x4*x5^2, x5^3, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, 1 ] ], 
  [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ], [ [ -E(4), 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], 
      [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ], 
  [ [ E(8)^3, 0, 0, 0, 0, 0 ], [ 0, E(4), 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], 
      [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-051` — `C24`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">72</td>
      <td style="white-space:nowrap;"><code>[72,14]</code></td>
      <td><code>C24 x C3</code></td>
      <td><code>[ 3, 3, 8 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">24</td>
      <td style="white-space:nowrap;"><code>[24,2]</code></td>
      <td><code>C24</code></td>
      <td><code>[ 3, 8 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **7**, centralizer in \(\mathrm{GL}_6\) **6**, family **1**.
- Determinant-one subgroup order: **3**.
- Sources merged: **1**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>Y21+T1</code>.

Invariant cubic basis (7 monomials):

```text
x1^2*x2, x2^2*x4, x2*x3*x5, x3^2*x4, x4^2*x5, x5^3, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, 1 ] ], 
  [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ], [ [ -E(4), 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], 
      [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ], 
  [ [ -E(8)^3, 0, 0, 0, 0, 0 ], [ 0, E(4), 0, 0, 0, 0 ], [ 0, 0, -E(4), 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], 
      [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-052` — `C16`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">48</td>
      <td style="white-space:nowrap;"><code>[48,2]</code></td>
      <td><code>C48</code></td>
      <td><code>[ 3, 16 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">16</td>
      <td style="white-space:nowrap;"><code>[16,1]</code></td>
      <td><code>C16</code></td>
      <td><code>[ 16 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **9**, centralizer in \(\mathrm{GL}_6\) **8**, family **1**.
- Determinant-one subgroup order: **3**.
- Sources merged: **2**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>T5+T1</code>, <code>T6</code>.

Invariant cubic basis (9 monomials):

```text
x1^2*x2, x2^2*x3, x3^2*x4, x4^2*x5, x4^2*x6, x5^3, x5^2*x6, x5*x6^2, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ -E(16)^3, 0, 0, 0, 0, 0 ], [ 0, -E(8), 0, 0, 0, 0 ], [ 0, 0, -E(4), 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], 
      [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ], 
  [ [ E(8)^3, 0, 0, 0, 0, 0 ], [ 0, E(4), 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], 
      [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ], 
  [ [ -E(4), 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ],
      [ 0, 0, 0, 0, 0, 1 ] ], [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], 
      [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

### `LA-053` — `C16`

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Model</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:115px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:180px;">Structure</th>
      <th style="min-width:140px;">Abelian invariants</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>GL</code></td>
      <td style="white-space:nowrap; text-align:right;">48</td>
      <td style="white-space:nowrap;"><code>[48,2]</code></td>
      <td><code>C48</code></td>
      <td><code>[ 3, 16 ]</code></td>
    </tr>
    <tr>
      <td><code>PGL</code></td>
      <td style="white-space:nowrap; text-align:right;">16</td>
      <td style="white-space:nowrap;"><code>[16,1]</code></td>
      <td><code>C16</code></td>
      <td><code>[ 16 ]</code></td>
    </tr>
  </tbody>
</table>

- Dimensions: invariant cubics **7**, centralizer in \(\mathrm{GL}_6\) **6**, family **1**.
- Determinant-one subgroup order: **3**.
- Sources merged: **1**.
- Source: Peng--Zheng Theorem 4.2 maximal types.
- Maximal source type(s): <code>Y31</code>.

Invariant cubic basis (7 monomials):

```text
x1^2*x2, x2^2*x3, x3^2*x5, x3*x4*x6, x4^2*x5, x5^2*x6, x6^3
```

<details>
<summary><strong>GAP generators</strong></summary>

```gap
[ [ [ E(3), 0, 0, 0, 0, 0 ], [ 0, E(3), 0, 0, 0, 0 ], [ 0, 0, E(3), 0, 0, 0 ], [ 0, 0, 0, E(3), 0, 0 ], 
      [ 0, 0, 0, 0, E(3), 0 ], [ 0, 0, 0, 0, 0, E(3) ] ], 
  [ [ -1, 0, 0, 0, 0, 0 ], [ 0, 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 1 ] ], [ [ E(4), 0, 0, 0, 0, 0 ], [ 0, -1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0, 0 ], 
      [ 0, 0, 0, 1, 0, 0 ], [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ], 
  [ [ E(8), 0, 0, 0, 0, 0 ], [ 0, -E(4), 0, 0, 0, 0 ], [ 0, 0, -1, 0, 0, 0 ], [ 0, 0, 0, -1, 0, 0 ], 
      [ 0, 0, 0, 0, 1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ], 
  [ [ E(16), 0, 0, 0, 0, 0 ], [ 0, -E(8)^3, 0, 0, 0, 0 ], [ 0, 0, E(4), 0, 0, 0 ], [ 0, 0, 0, -E(4), 0, 0 ], 
      [ 0, 0, 0, 0, -1, 0 ], [ 0, 0, 0, 0, 0, 1 ] ] ]
```

</details>

## Consistency checks

The saved result was checked as follows:

- The labels are consecutive from `LA-001` through `LA-053`.
- The human-readable output and `gap_liftable_abelian_data.g` contain the same 53 labels in the same order.
- A static audit of all 53 records found identical group metadata, dimensions, source lists, ordered generators, and ordered invariant bases in the data file, saved output, and detailed tables.
- There are exactly 51 ordinary candidates and two special candidates.
- The historical comparison with the preceding 51-record result found the same candidate order, all 459 compared metadata fields, all 51 source lists, invariant monomial bases, and ordered diagonal-generator lists. This comparison is separate from the two count checks performed by the entry point.
- Every linear order is three times the corresponding projective order, as expected from the scalar subgroup `mu_3`.
- The order recorded in every GL and PGL `IdGroup` value agrees with the computed group order; no exported ID is `fail`.
- For every row, `family dimension = invariant cubic dimension - centralizer GL dimension`.
- The number of printed invariant monomials equals the recorded invariant cubic dimension.
- The log and machine-data files both report that the ordinary count 51 and total count 53 match the reference values.

## Interpretation

The 51 ordinary rows are equivalence classes of the diagonal representations surviving the restrictions in the original core. They are not merely a list of abstract abelian groups. The same abstract PGL group can therefore occur in several rows when its six-dimensional representation, invariant cubic space, or family dimension is different.

For an ordinary row, smoothness follows from its construction inside a Peng--Zheng maximal liftable type: the subgroup-invariant cubic space contains the smooth cubic belonging to that maximal type. For `LA-001` and `LA-002`, the six displayed monomials are the invariant bases of the special `C48` and `C32` examples.

The spectral exclusions in the core seek an abelian full projective
stabilizer. They do not assert that the excluded subgroup actions have no
smooth invariant cubic. Local equal-dimensional pruning and cross-source
equivalence deduplication do not replace the subsequent saturation
calculation.

The documentation and source-reference text have been tidied without
rerunning the enumeration. The candidate order, matrix generators, invariant
bases, group IDs, dimensions, and counts are unchanged. The original runtime
log is retained verbatim.
