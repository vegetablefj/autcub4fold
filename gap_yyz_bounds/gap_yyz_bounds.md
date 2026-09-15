# GAP calculation of the YYZ group-theoretic bounds

This calculation compares the 34 symplectic automorphism groups in the Laza–Zheng classification with the 15 maximal groups of Yang–Yu–Zhu. For a candidate full automorphism group, the symplectic group is required to be normal with cyclic quotient, and the admissible index is restricted to $m=2^a$ or $m=3\cdot 2^a$.

The output is group-theoretic: a listed row is a necessary candidate inside the YYZ maximal groups, not by itself a geometric realizability statement. Indices with no candidate are omitted here; their complete audit information is retained in `gap_yyz_bounds_output.txt` and `gap_yyz_bounds_log.txt`.

## Run information

- GAP version: `4.15.1`
- Raw successful subgroup occurrences: **2,649**
- Final deduplicated records: **218**
- Total runtime: **167.5 s**
- Audit output: `gap_yyz_bounds_output.txt`
- Runtime log: `gap_yyz_bounds_log.txt`

> **Notation.** The 15 Yang–Yu–Zhu maximal source groups are denoted $H_1,\ldots,H_{15}$ below. The attached run used the same ordering with `M_i` in the source labels; here they are relabeled uniformly as `H_i`.

## Yang–Yu–Zhu maximal source groups

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Source</th>
      <th style="min-width:260px;">YYZ notation</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:125px; min-width:125px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:320px;">GAP structure description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap;"><code>H_1</code></td>
      <td><code>C3^5 : S6</code></td>
      <td style="white-space:nowrap; text-align:right;">174960</td>
      <td style="white-space:nowrap;">—</td>
      <td><code>((C3 x C3 x C3 x C3) : A6) : C6</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>H_2</code></td>
      <td><code>((C3 x (C3^3 : C3)) : C3) : (C4 x C2)</code></td>
      <td style="white-space:nowrap; text-align:right;">5832</td>
      <td style="white-space:nowrap;">—</td>
      <td><code>((C3 x ((C3 x C3 x C3) : C3)) : C3) : (C4 x C2)</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>H_3</code></td>
      <td><code>C8 x (C3^2 : C2)</code></td>
      <td style="white-space:nowrap; text-align:right;">144</td>
      <td style="white-space:nowrap;"><code>[144,69]</code></td>
      <td><code>C24 x S3</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>H_4</code></td>
      <td><code>S5 x (C3^2 : C2)</code></td>
      <td style="white-space:nowrap; text-align:right;">2160</td>
      <td style="white-space:nowrap;">—</td>
      <td><code>C3 x S3 x S5</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>H_5</code></td>
      <td><code>C48</code></td>
      <td style="white-space:nowrap; text-align:right;">48</td>
      <td style="white-space:nowrap;"><code>[48,2]</code></td>
      <td><code>C48</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>H_6</code></td>
      <td><code>PSL(2,11) x C3</code></td>
      <td style="white-space:nowrap; text-align:right;">1980</td>
      <td style="white-space:nowrap;"><code>[1980,57]</code></td>
      <td><code>C3 x PSL(2,11)</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>H_7</code></td>
      <td><code>((C3 x (C3^2 : C3)) : C3) : (C4^2 : C2)</code></td>
      <td style="white-space:nowrap; text-align:right;">7776</td>
      <td style="white-space:nowrap;">—</td>
      <td><code>((C3 x ((C3 x C3) : C3)) : C3) : ((C4 x C4) : C2)</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>H_8</code></td>
      <td><code>C32</code></td>
      <td style="white-space:nowrap; text-align:right;">32</td>
      <td style="white-space:nowrap;"><code>[32,1]</code></td>
      <td><code>C32</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>H_9</code></td>
      <td><code>C21 : C6</code></td>
      <td style="white-space:nowrap; text-align:right;">126</td>
      <td style="white-space:nowrap;"><code>[126,7]</code></td>
      <td><code>C3 x (C7 : C6)</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>H_10</code></td>
      <td><code>M10</code></td>
      <td style="white-space:nowrap; text-align:right;">720</td>
      <td style="white-space:nowrap;"><code>[720,765]</code></td>
      <td><code>A6 . C2</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>H_11</code></td>
      <td><code>S7</code></td>
      <td style="white-space:nowrap; text-align:right;">5040</td>
      <td style="white-space:nowrap;">—</td>
      <td><code>S7</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>H_12</code></td>
      <td><code>(C8 x C2) : C2</code></td>
      <td style="white-space:nowrap; text-align:right;">32</td>
      <td style="white-space:nowrap;"><code>[32,42]</code></td>
      <td><code>(C8 x C2) : C2</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>H_13</code></td>
      <td><code>PSL(3,2) : C2</code></td>
      <td style="white-space:nowrap; text-align:right;">336</td>
      <td style="white-space:nowrap;"><code>[336,208]</code></td>
      <td><code>PSL(3,2) : C2</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>H_14</code></td>
      <td><code>GL(2,3)</code></td>
      <td style="white-space:nowrap; text-align:right;">48</td>
      <td style="white-space:nowrap;"><code>[48,29]</code></td>
      <td><code>GL(2,3)</code></td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>H_15</code></td>
      <td><code>(C3^2 : Q8) : C3</code></td>
      <td style="white-space:nowrap; text-align:right;">216</td>
      <td style="white-space:nowrap;"><code>[216,153]</code></td>
      <td><code>((C3 x C3) : Q8) : C3</code></td>
    </tr>
  </tbody>
</table>

## Laza–Zheng symplectic groups

The labels $G_i$ follow the ordering used in the calculation; the second column gives the corresponding Laza–Zheng notation.

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap;">Label</th>
      <th style="min-width:220px;">Laza–Zheng notation</th>
      <th style="width:90px; white-space:nowrap; text-align:right;">Order</th>
      <th style="width:80px; white-space:nowrap; text-align:right;"><i>r</i>(<i>S</i>)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap;"><code>G_1</code></td>
      <td>3<sup>4</sup>:A<sub>6</sub></td>
      <td style="white-space:nowrap; text-align:right;">29160</td>
      <td style="white-space:nowrap; text-align:right;">20</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>G_2</code></td>
      <td>A<sub>7</sub></td>
      <td style="white-space:nowrap; text-align:right;">2520</td>
      <td style="white-space:nowrap; text-align:right;">20</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>G_3</code></td>
      <td>3<sup>1+4</sup>:2.2<sup>2</sup></td>
      <td style="white-space:nowrap; text-align:right;">1944</td>
      <td style="white-space:nowrap; text-align:right;">20</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>G_4</code></td>
      <td>M<sub>10</sub></td>
      <td style="white-space:nowrap; text-align:right;">720</td>
      <td style="white-space:nowrap; text-align:right;">20</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>G_5</code></td>
      <td>L<sub>2</sub>(11)</td>
      <td style="white-space:nowrap; text-align:right;">660</td>
      <td style="white-space:nowrap; text-align:right;">20</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>G_6</code></td>
      <td>A<sub>3,5</sub></td>
      <td style="white-space:nowrap; text-align:right;">360</td>
      <td style="white-space:nowrap; text-align:right;">20</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>G_7</code></td>
      <td>3<sup>1+4</sup>:2.2</td>
      <td style="white-space:nowrap; text-align:right;">972</td>
      <td style="white-space:nowrap; text-align:right;">19</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>G_8</code></td>
      <td>A<sub>6</sub></td>
      <td style="white-space:nowrap; text-align:right;">360</td>
      <td style="white-space:nowrap; text-align:right;">19</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>G_9</code></td>
      <td>L<sub>2</sub>(7)</td>
      <td style="white-space:nowrap; text-align:right;">168</td>
      <td style="white-space:nowrap; text-align:right;">19</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>G_10</code></td>
      <td>S<sub>5</sub></td>
      <td style="white-space:nowrap; text-align:right;">120</td>
      <td style="white-space:nowrap; text-align:right;">19</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>G_11</code></td>
      <td>M<sub>9</sub></td>
      <td style="white-space:nowrap; text-align:right;">72</td>
      <td style="white-space:nowrap; text-align:right;">19</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>G_12</code></td>
      <td>N<sub>72</sub></td>
      <td style="white-space:nowrap; text-align:right;">72</td>
      <td style="white-space:nowrap; text-align:right;">19</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>G_13</code></td>
      <td>T<sub>48</sub></td>
      <td style="white-space:nowrap; text-align:right;">48</td>
      <td style="white-space:nowrap; text-align:right;">19</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>G_14</code></td>
      <td>3<sup>1+4</sup>:2</td>
      <td style="white-space:nowrap; text-align:right;">486</td>
      <td style="white-space:nowrap; text-align:right;">18</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>G_15</code></td>
      <td>A<sub>4,3</sub></td>
      <td style="white-space:nowrap; text-align:right;">72</td>
      <td style="white-space:nowrap; text-align:right;">18</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>G_16</code></td>
      <td>A<sub>5</sub></td>
      <td style="white-space:nowrap; text-align:right;">60</td>
      <td style="white-space:nowrap; text-align:right;">18</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>G_17</code></td>
      <td>3<sup>2</sup>.4</td>
      <td style="white-space:nowrap; text-align:right;">36</td>
      <td style="white-space:nowrap; text-align:right;">18</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>G_18</code></td>
      <td>S<sub>3,3</sub></td>
      <td style="white-space:nowrap; text-align:right;">36</td>
      <td style="white-space:nowrap; text-align:right;">18</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>G_19</code></td>
      <td>F<sub>21</sub></td>
      <td style="white-space:nowrap; text-align:right;">21</td>
      <td style="white-space:nowrap; text-align:right;">18</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>G_20</code></td>
      <td>Hol(5)</td>
      <td style="white-space:nowrap; text-align:right;">20</td>
      <td style="white-space:nowrap; text-align:right;">18</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>G_21</code></td>
      <td>QD<sub>16</sub></td>
      <td style="white-space:nowrap; text-align:right;">16</td>
      <td style="white-space:nowrap; text-align:right;">18</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>G_22</code></td>
      <td>S<sub>4</sub></td>
      <td style="white-space:nowrap; text-align:right;">24</td>
      <td style="white-space:nowrap; text-align:right;">17</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>G_23</code></td>
      <td>Q<sub>8</sub></td>
      <td style="white-space:nowrap; text-align:right;">8</td>
      <td style="white-space:nowrap; text-align:right;">17</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>G_24</code></td>
      <td>A<sub>3,3</sub></td>
      <td style="white-space:nowrap; text-align:right;">18</td>
      <td style="white-space:nowrap; text-align:right;">16</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>G_25</code></td>
      <td>D<sub>12</sub></td>
      <td style="white-space:nowrap; text-align:right;">12</td>
      <td style="white-space:nowrap; text-align:right;">16</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>G_26</code></td>
      <td>A<sub>4</sub></td>
      <td style="white-space:nowrap; text-align:right;">12</td>
      <td style="white-space:nowrap; text-align:right;">16</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>G_27</code></td>
      <td>D<sub>10</sub></td>
      <td style="white-space:nowrap; text-align:right;">10</td>
      <td style="white-space:nowrap; text-align:right;">16</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>G_28</code></td>
      <td>D<sub>8</sub></td>
      <td style="white-space:nowrap; text-align:right;">8</td>
      <td style="white-space:nowrap; text-align:right;">15</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>G_29</code></td>
      <td>C<sub>4</sub></td>
      <td style="white-space:nowrap; text-align:right;">4</td>
      <td style="white-space:nowrap; text-align:right;">14</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>G_30</code></td>
      <td>S<sub>3</sub></td>
      <td style="white-space:nowrap; text-align:right;">6</td>
      <td style="white-space:nowrap; text-align:right;">14</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>G_31</code></td>
      <td>C<sub>2</sub><sup>2</sup></td>
      <td style="white-space:nowrap; text-align:right;">4</td>
      <td style="white-space:nowrap; text-align:right;">12</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>G_32</code></td>
      <td>C<sub>3</sub></td>
      <td style="white-space:nowrap; text-align:right;">3</td>
      <td style="white-space:nowrap; text-align:right;">12</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>G_33</code></td>
      <td>C<sub>2</sub></td>
      <td style="white-space:nowrap; text-align:right;">2</td>
      <td style="white-space:nowrap; text-align:right;">8</td>
    </tr>
    <tr>
      <td style="white-space:nowrap;"><code>G_34</code></td>
      <td>1</td>
      <td style="white-space:nowrap; text-align:right;">1</td>
      <td style="white-space:nowrap; text-align:right;">0</td>
    </tr>
  </tbody>
</table>

## Results

Only indices with at least one candidate are shown. Unlisted admissible indices produce no candidate in the YYZ maximal-group search; complete zero-result data remain in `gap_yyz_bounds_output.txt` and `gap_yyz_bounds_log.txt`. Candidates sharing the same index are grouped under one index entry and displayed on separate rows.

> **Special case $G_{14}$.** As in the GAP calculation, full groups above $G_{14}=3^{1+4}\!:\!2$ are not abstractly identified; occurrences are merged only by index and source. Hence one row may represent more than one non-isomorphic full group.

### `G_1` — $3^4\!:\!A_6$

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap; text-align:right;">Index <i>m</i></th>
      <th style="min-width:280px;">Candidate full group</th>
      <th style="width:125px; min-width:125px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:240px;">YYZ source(s)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">1</td>
      <td><code>(C3 x C3 x C3 x C3) : A6</code></td>
      <td style="white-space:nowrap;">—</td>
      <td><code>H_1</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">2</td>
      <td><code>(C3 x C3 x C3 x C3) : S6</code></td>
      <td style="white-space:nowrap;">—</td>
      <td><code>H_1</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">3</td>
      <td><code>((C3 x C3 x C3 x C3) : A6) : C3</code></td>
      <td style="white-space:nowrap;">—</td>
      <td><code>H_1</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">6</td>
      <td><code>((C3 x C3 x C3 x C3) : A6) : C6</code></td>
      <td style="white-space:nowrap;">—</td>
      <td><code>H_1</code></td>
    </tr>
  </tbody>
</table>

### `G_2` — $A_7$

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap; text-align:right;">Index <i>m</i></th>
      <th style="min-width:280px;">Candidate full group</th>
      <th style="width:125px; min-width:125px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:240px;">YYZ source(s)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">1</td>
      <td><code>A7</code></td>
      <td style="white-space:nowrap;">—</td>
      <td><code>H_11</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">2</td>
      <td><code>S7</code></td>
      <td style="white-space:nowrap;">—</td>
      <td><code>H_11</code></td>
    </tr>
  </tbody>
</table>

### `G_3` — $3^{1+4}\!:\!2.2^2$

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap; text-align:right;">Index <i>m</i></th>
      <th style="min-width:280px;">Candidate full group</th>
      <th style="width:125px; min-width:125px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:240px;">YYZ source(s)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">1</td>
      <td><code>((C3 x ((C3 x C3) : C3)) : C3) : Q8</code></td>
      <td style="white-space:nowrap;"><code>[1944,3559]</code></td>
      <td><code>H_7</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">2</td>
      <td><code>((C3 x ((C3 x C3) : C3)) : C3) : ((C4 x C2) : C2)</code></td>
      <td style="white-space:nowrap;">—</td>
      <td><code>H_7</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">4</td>
      <td><code>((C3 x ((C3 x C3) : C3)) : C3) : ((C4 x C4) : C2)</code></td>
      <td style="white-space:nowrap;">—</td>
      <td><code>H_7</code></td>
    </tr>
  </tbody>
</table>

### `G_4` — $M_{10}$

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap; text-align:right;">Index <i>m</i></th>
      <th style="min-width:280px;">Candidate full group</th>
      <th style="width:125px; min-width:125px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:240px;">YYZ source(s)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">1</td>
      <td><code>A6 . C2</code></td>
      <td style="white-space:nowrap;"><code>[720,765]</code></td>
      <td><code>H_10</code></td>
    </tr>
  </tbody>
</table>

### `G_5` — $L_2(11)$

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap; text-align:right;">Index <i>m</i></th>
      <th style="min-width:280px;">Candidate full group</th>
      <th style="width:125px; min-width:125px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:240px;">YYZ source(s)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">1</td>
      <td><code>PSL(2,11)</code></td>
      <td style="white-space:nowrap;"><code>[660,13]</code></td>
      <td><code>H_6</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">3</td>
      <td><code>C3 x PSL(2,11)</code></td>
      <td style="white-space:nowrap;"><code>[1980,57]</code></td>
      <td><code>H_6</code></td>
    </tr>
  </tbody>
</table>

### `G_6` — $A_{3,5}$

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap; text-align:right;">Index <i>m</i></th>
      <th style="min-width:280px;">Candidate full group</th>
      <th style="width:125px; min-width:125px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:240px;">YYZ source(s)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">1</td>
      <td><code>A5 : S3</code></td>
      <td style="white-space:nowrap;"><code>[360,120]</code></td>
      <td><code>H_4</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">2</td>
      <td><code>S5 x S3</code></td>
      <td style="white-space:nowrap;"><code>[720,767]</code></td>
      <td><code>H_4</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">3</td>
      <td><code>C3 x (A5 : S3)</code></td>
      <td style="white-space:nowrap;"><code>[1080,489]</code></td>
      <td><code>H_4</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">6</td>
      <td><code>C3 x S3 x S5</code></td>
      <td style="white-space:nowrap;">—</td>
      <td><code>H_4</code></td>
    </tr>
  </tbody>
</table>

### `G_7` — $3^{1+4}\!:\!2.2$

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap; text-align:right;">Index <i>m</i></th>
      <th style="min-width:280px;">Candidate full group</th>
      <th style="width:125px; min-width:125px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:240px;">YYZ source(s)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">1</td>
      <td><code>((C3 x ((C3 x C3) : C3)) : C3) : C4</code></td>
      <td style="white-space:nowrap;"><code>[972,776]</code></td>
      <td><code>H_1</code>, <code>H_7</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="3" style="white-space:nowrap; text-align:right; vertical-align:top;">2</td>
      <td><code>((C3 x ((C3 x C3) : C3)) : C3) : (C4 x C2)</code></td>
      <td style="white-space:nowrap;"><code>[1944,3498]</code></td>
      <td><code>H_7</code></td>
    </tr>
    <tr>
      <td><code>((C3 x ((C3 x C3) : C3)) : C3) : D8</code></td>
      <td style="white-space:nowrap;"><code>[1944,3536]</code></td>
      <td><code>H_1</code>, <code>H_7</code></td>
    </tr>
    <tr>
      <td><code>((C3 x ((C3 x C3) : C3)) : C3) : Q8</code></td>
      <td style="white-space:nowrap;"><code>[1944,3559]</code></td>
      <td><code>H_7</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">3</td>
      <td><code>((C3 x ((C3 x C3 x C3) : C3)) : C3) : C4</code></td>
      <td style="white-space:nowrap;">—</td>
      <td><code>H_1</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">6</td>
      <td><code>((C3 x ((C3 x C3 x C3) : C3)) : C3) : D8</code></td>
      <td style="white-space:nowrap;">—</td>
      <td><code>H_1</code></td>
    </tr>
  </tbody>
</table>

### `G_8` — $A_6$

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap; text-align:right;">Index <i>m</i></th>
      <th style="min-width:280px;">Candidate full group</th>
      <th style="width:125px; min-width:125px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:240px;">YYZ source(s)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">1</td>
      <td><code>A6</code></td>
      <td style="white-space:nowrap;"><code>[360,118]</code></td>
      <td><code>H_1</code>, <code>H_10</code>, <code>H_11</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="2" style="white-space:nowrap; text-align:right; vertical-align:top;">2</td>
      <td><code>S6</code></td>
      <td style="white-space:nowrap;"><code>[720,763]</code></td>
      <td><code>H_1</code>, <code>H_11</code></td>
    </tr>
    <tr>
      <td><code>A6 . C2</code></td>
      <td style="white-space:nowrap;"><code>[720,765]</code></td>
      <td><code>H_10</code></td>
    </tr>
  </tbody>
</table>

### `G_9` — $L_2(7)$

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap; text-align:right;">Index <i>m</i></th>
      <th style="min-width:280px;">Candidate full group</th>
      <th style="width:125px; min-width:125px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:240px;">YYZ source(s)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">1</td>
      <td><code>PSL(3,2)</code></td>
      <td style="white-space:nowrap;"><code>[168,42]</code></td>
      <td><code>H_11</code>, <code>H_13</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">2</td>
      <td><code>PSL(3,2) : C2</code></td>
      <td style="white-space:nowrap;"><code>[336,208]</code></td>
      <td><code>H_13</code></td>
    </tr>
  </tbody>
</table>

### `G_10` — $S_5$

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap; text-align:right;">Index <i>m</i></th>
      <th style="min-width:280px;">Candidate full group</th>
      <th style="width:125px; min-width:125px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:240px;">YYZ source(s)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">1</td>
      <td><code>S5</code></td>
      <td style="white-space:nowrap;"><code>[120,34]</code></td>
      <td><code>H_1</code>, <code>H_4</code>, <code>H_11</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">2</td>
      <td><code>C2 x S5</code></td>
      <td style="white-space:nowrap;"><code>[240,189]</code></td>
      <td><code>H_4</code>, <code>H_11</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">3</td>
      <td><code>C3 x S5</code></td>
      <td style="white-space:nowrap;"><code>[360,119]</code></td>
      <td><code>H_1</code>, <code>H_4</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">6</td>
      <td><code>C6 x S5</code></td>
      <td style="white-space:nowrap;"><code>[720,769]</code></td>
      <td><code>H_4</code></td>
    </tr>
  </tbody>
</table>

### `G_11` — $M_9$

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap; text-align:right;">Index <i>m</i></th>
      <th style="min-width:280px;">Candidate full group</th>
      <th style="width:125px; min-width:125px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:240px;">YYZ source(s)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">1</td>
      <td><code>(C3 x C3) : Q8</code></td>
      <td style="white-space:nowrap;"><code>[72,41]</code></td>
      <td><code>H_7</code>, <code>H_10</code>, <code>H_15</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">3</td>
      <td><code>((C3 x C3) : Q8) : C3</code></td>
      <td style="white-space:nowrap;"><code>[216,153]</code></td>
      <td><code>H_15</code></td>
    </tr>
  </tbody>
</table>

### `G_12` — $N_{72}$

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap; text-align:right;">Index <i>m</i></th>
      <th style="min-width:280px;">Candidate full group</th>
      <th style="width:125px; min-width:125px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:240px;">YYZ source(s)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">1</td>
      <td><code>(S3 x S3) : C2</code></td>
      <td style="white-space:nowrap;"><code>[72,40]</code></td>
      <td><code>H_1</code>, <code>H_7</code>, <code>H_11</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">2</td>
      <td><code>C2 x ((S3 x S3) : C2)</code></td>
      <td style="white-space:nowrap;"><code>[144,186]</code></td>
      <td><code>H_1</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">3</td>
      <td><code>C3 x ((S3 x S3) : C2)</code></td>
      <td style="white-space:nowrap;"><code>[216,157]</code></td>
      <td><code>H_1</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">6</td>
      <td><code>C6 x ((S3 x S3) : C2)</code></td>
      <td style="white-space:nowrap;"><code>[432,754]</code></td>
      <td><code>H_1</code></td>
    </tr>
  </tbody>
</table>

### `G_13` — $T_{48}$

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap; text-align:right;">Index <i>m</i></th>
      <th style="min-width:280px;">Candidate full group</th>
      <th style="width:125px; min-width:125px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:240px;">YYZ source(s)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">1</td>
      <td><code>GL(2,3)</code></td>
      <td style="white-space:nowrap;"><code>[48,29]</code></td>
      <td><code>H_14</code></td>
    </tr>
  </tbody>
</table>

### `G_14` — $3^{1+4}\!:\!2$

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap; text-align:right;">Index <i>m</i></th>
      <th style="min-width:280px;">Candidate full group</th>
      <th style="width:125px; min-width:125px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:240px;">YYZ source(s)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">1</td>
      <td>unidentified</td>
      <td style="white-space:nowrap;">—</td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_7</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">2</td>
      <td>unidentified</td>
      <td style="white-space:nowrap;">—</td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_7</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">3</td>
      <td>unidentified</td>
      <td style="white-space:nowrap;">—</td>
      <td><code>H_1</code>, <code>H_2</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">4</td>
      <td>unidentified</td>
      <td style="white-space:nowrap;">—</td>
      <td><code>H_2</code>, <code>H_7</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">6</td>
      <td>unidentified</td>
      <td style="white-space:nowrap;">—</td>
      <td><code>H_1</code>, <code>H_2</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">12</td>
      <td>unidentified</td>
      <td style="white-space:nowrap;">—</td>
      <td><code>H_2</code></td>
    </tr>
  </tbody>
</table>

### `G_15` — $A_{4,3}$

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap; text-align:right;">Index <i>m</i></th>
      <th style="min-width:280px;">Candidate full group</th>
      <th style="width:125px; min-width:125px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:240px;">YYZ source(s)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">1</td>
      <td><code>(C3 x A4) : C2</code></td>
      <td style="white-space:nowrap;"><code>[72,43]</code></td>
      <td><code>H_1</code>, <code>H_4</code>, <code>H_11</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="2" style="white-space:nowrap; text-align:right; vertical-align:top;">2</td>
      <td><code>S3 x S4</code></td>
      <td style="white-space:nowrap;"><code>[144,183]</code></td>
      <td><code>H_1</code>, <code>H_4</code>, <code>H_11</code></td>
    </tr>
    <tr>
      <td><code>C2 x ((C3 x A4) : C2)</code></td>
      <td style="white-space:nowrap;"><code>[144,189]</code></td>
      <td><code>H_1</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="2" style="white-space:nowrap; text-align:right; vertical-align:top;">3</td>
      <td><code>((C3 x A4) : C2) : C3</code></td>
      <td style="white-space:nowrap;"><code>[216,92]</code></td>
      <td><code>H_1</code></td>
    </tr>
    <tr>
      <td><code>C3 x ((C3 x A4) : C2)</code></td>
      <td style="white-space:nowrap;"><code>[216,164]</code></td>
      <td><code>H_1</code>, <code>H_4</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="2" style="white-space:nowrap; text-align:right; vertical-align:top;">6</td>
      <td><code>C2 x (((C3 x A4) : C2) : C3)</code></td>
      <td style="white-space:nowrap;"><code>[432,535]</code></td>
      <td><code>H_1</code></td>
    </tr>
    <tr>
      <td><code>C3 x S3 x S4</code></td>
      <td style="white-space:nowrap;"><code>[432,745]</code></td>
      <td><code>H_1</code>, <code>H_4</code></td>
    </tr>
  </tbody>
</table>

### `G_16` — $A_5$

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap; text-align:right;">Index <i>m</i></th>
      <th style="min-width:280px;">Candidate full group</th>
      <th style="width:125px; min-width:125px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:240px;">YYZ source(s)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">1</td>
      <td><code>A5</code></td>
      <td style="white-space:nowrap;"><code>[60,5]</code></td>
      <td><code>H_1</code>, <code>H_4</code>, <code>H_6</code>, <code>H_10</code>, <code>H_11</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="2" style="white-space:nowrap; text-align:right; vertical-align:top;">2</td>
      <td><code>S5</code></td>
      <td style="white-space:nowrap;"><code>[120,34]</code></td>
      <td><code>H_1</code>, <code>H_4</code>, <code>H_11</code></td>
    </tr>
    <tr>
      <td><code>C2 x A5</code></td>
      <td style="white-space:nowrap;"><code>[120,35]</code></td>
      <td><code>H_4</code>, <code>H_11</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">3</td>
      <td><code>GL(2,4)</code></td>
      <td style="white-space:nowrap;"><code>[180,19]</code></td>
      <td><code>H_1</code>, <code>H_4</code>, <code>H_6</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="2" style="white-space:nowrap; text-align:right; vertical-align:top;">6</td>
      <td><code>C3 x S5</code></td>
      <td style="white-space:nowrap;"><code>[360,119]</code></td>
      <td><code>H_1</code>, <code>H_4</code></td>
    </tr>
    <tr>
      <td><code>C6 x A5</code></td>
      <td style="white-space:nowrap;"><code>[360,122]</code></td>
      <td><code>H_4</code></td>
    </tr>
  </tbody>
</table>

### `G_17` — $3^2.4$

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap; text-align:right;">Index <i>m</i></th>
      <th style="min-width:280px;">Candidate full group</th>
      <th style="width:125px; min-width:125px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:240px;">YYZ source(s)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">1</td>
      <td><code>(C3 x C3) : C4</code></td>
      <td style="white-space:nowrap;"><code>[36,9]</code></td>
      <td><code>H_1</code>, <code>H_7</code>, <code>H_10</code>, <code>H_11</code>, <code>H_15</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="3" style="white-space:nowrap; text-align:right; vertical-align:top;">2</td>
      <td><code>(S3 x S3) : C2</code></td>
      <td style="white-space:nowrap;"><code>[72,40]</code></td>
      <td><code>H_1</code>, <code>H_7</code>, <code>H_11</code></td>
    </tr>
    <tr>
      <td><code>(C3 x C3) : Q8</code></td>
      <td style="white-space:nowrap;"><code>[72,41]</code></td>
      <td><code>H_7</code>, <code>H_10</code>, <code>H_15</code></td>
    </tr>
    <tr>
      <td><code>C2 x ((C3 x C3) : C4)</code></td>
      <td style="white-space:nowrap;"><code>[72,45]</code></td>
      <td><code>H_1</code>, <code>H_7</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">3</td>
      <td><code>C3 x ((C3 x C3) : C4)</code></td>
      <td style="white-space:nowrap;"><code>[108,36]</code></td>
      <td><code>H_1</code>, <code>H_7</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="2" style="white-space:nowrap; text-align:right; vertical-align:top;">6</td>
      <td><code>C3 x ((S3 x S3) : C2)</code></td>
      <td style="white-space:nowrap;"><code>[216,157]</code></td>
      <td><code>H_1</code></td>
    </tr>
    <tr>
      <td><code>C6 x ((C3 x C3) : C4)</code></td>
      <td style="white-space:nowrap;"><code>[216,168]</code></td>
      <td><code>H_1</code></td>
    </tr>
  </tbody>
</table>

### `G_18` — $S_{3,3}$

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap; text-align:right;">Index <i>m</i></th>
      <th style="min-width:280px;">Candidate full group</th>
      <th style="width:125px; min-width:125px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:240px;">YYZ source(s)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">1</td>
      <td><code>S3 x S3</code></td>
      <td style="white-space:nowrap;"><code>[36,10]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_4</code>, <code>H_7</code>, <code>H_11</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="2" style="white-space:nowrap; text-align:right; vertical-align:top;">2</td>
      <td><code>(S3 x S3) : C2</code></td>
      <td style="white-space:nowrap;"><code>[72,40]</code></td>
      <td><code>H_1</code>, <code>H_7</code>, <code>H_11</code></td>
    </tr>
    <tr>
      <td><code>C2 x S3 x S3</code></td>
      <td style="white-space:nowrap;"><code>[72,46]</code></td>
      <td><code>H_1</code>, <code>H_4</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">3</td>
      <td><code>C3 x S3 x S3</code></td>
      <td style="white-space:nowrap;"><code>[108,38]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_4</code>, <code>H_7</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="2" style="white-space:nowrap; text-align:right; vertical-align:top;">6</td>
      <td><code>C3 x ((S3 x S3) : C2)</code></td>
      <td style="white-space:nowrap;"><code>[216,157]</code></td>
      <td><code>H_1</code></td>
    </tr>
    <tr>
      <td><code>C6 x S3 x S3</code></td>
      <td style="white-space:nowrap;"><code>[216,170]</code></td>
      <td><code>H_1</code>, <code>H_4</code></td>
    </tr>
  </tbody>
</table>

### `G_19` — $F_{21}$

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap; text-align:right;">Index <i>m</i></th>
      <th style="min-width:280px;">Candidate full group</th>
      <th style="width:125px; min-width:125px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:240px;">YYZ source(s)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">1</td>
      <td><code>C7 : C3</code></td>
      <td style="white-space:nowrap;"><code>[21,1]</code></td>
      <td><code>H_9</code>, <code>H_11</code>, <code>H_13</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">2</td>
      <td><code>C7 : C6</code></td>
      <td style="white-space:nowrap;"><code>[42,1]</code></td>
      <td><code>H_9</code>, <code>H_11</code>, <code>H_13</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">3</td>
      <td><code>C3 x (C7 : C3)</code></td>
      <td style="white-space:nowrap;"><code>[63,3]</code></td>
      <td><code>H_9</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">6</td>
      <td><code>C3 x (C7 : C6)</code></td>
      <td style="white-space:nowrap;"><code>[126,7]</code></td>
      <td><code>H_9</code></td>
    </tr>
  </tbody>
</table>

### `G_20` — $\operatorname{Hol}(5)$

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap; text-align:right;">Index <i>m</i></th>
      <th style="min-width:280px;">Candidate full group</th>
      <th style="width:125px; min-width:125px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:240px;">YYZ source(s)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">1</td>
      <td><code>C5 : C4</code></td>
      <td style="white-space:nowrap;"><code>[20,3]</code></td>
      <td><code>H_1</code>, <code>H_4</code>, <code>H_10</code>, <code>H_11</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">2</td>
      <td><code>C2 x (C5 : C4)</code></td>
      <td style="white-space:nowrap;"><code>[40,12]</code></td>
      <td><code>H_4</code>, <code>H_11</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">3</td>
      <td><code>C3 x (C5 : C4)</code></td>
      <td style="white-space:nowrap;"><code>[60,6]</code></td>
      <td><code>H_1</code>, <code>H_4</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">6</td>
      <td><code>C6 x (C5 : C4)</code></td>
      <td style="white-space:nowrap;"><code>[120,40]</code></td>
      <td><code>H_4</code></td>
    </tr>
  </tbody>
</table>

### `G_21` — $QD_{16}$

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap; text-align:right;">Index <i>m</i></th>
      <th style="min-width:280px;">Candidate full group</th>
      <th style="width:125px; min-width:125px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:240px;">YYZ source(s)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">1</td>
      <td><code>QD16</code></td>
      <td style="white-space:nowrap;"><code>[16,8]</code></td>
      <td><code>H_10</code>, <code>H_12</code>, <code>H_14</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">2</td>
      <td><code>(C8 x C2) : C2</code></td>
      <td style="white-space:nowrap;"><code>[32,42]</code></td>
      <td><code>H_12</code></td>
    </tr>
  </tbody>
</table>

### `G_22` — $S_4$

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap; text-align:right;">Index <i>m</i></th>
      <th style="min-width:280px;">Candidate full group</th>
      <th style="width:125px; min-width:125px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:240px;">YYZ source(s)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">1</td>
      <td><code>S4</code></td>
      <td style="white-space:nowrap;"><code>[24,12]</code></td>
      <td><code>H_1</code>, <code>H_4</code>, <code>H_10</code>, <code>H_11</code>, <code>H_13</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">2</td>
      <td><code>C2 x S4</code></td>
      <td style="white-space:nowrap;"><code>[48,48]</code></td>
      <td><code>H_1</code>, <code>H_4</code>, <code>H_11</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">3</td>
      <td><code>C3 x S4</code></td>
      <td style="white-space:nowrap;"><code>[72,42]</code></td>
      <td><code>H_1</code>, <code>H_4</code>, <code>H_11</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">6</td>
      <td><code>C6 x S4</code></td>
      <td style="white-space:nowrap;"><code>[144,188]</code></td>
      <td><code>H_1</code>, <code>H_4</code></td>
    </tr>
  </tbody>
</table>

### `G_23` — $Q_8$

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap; text-align:right;">Index <i>m</i></th>
      <th style="min-width:280px;">Candidate full group</th>
      <th style="width:125px; min-width:125px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:240px;">YYZ source(s)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">1</td>
      <td><code>Q8</code></td>
      <td style="white-space:nowrap;"><code>[8,4]</code></td>
      <td><code>H_7</code>, <code>H_10</code>, <code>H_12</code>, <code>H_14</code>, <code>H_15</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="3" style="white-space:nowrap; text-align:right; vertical-align:top;">2</td>
      <td><code>QD16</code></td>
      <td style="white-space:nowrap;"><code>[16,8]</code></td>
      <td><code>H_10</code>, <code>H_12</code>, <code>H_14</code></td>
    </tr>
    <tr>
      <td><code>Q16</code></td>
      <td style="white-space:nowrap;"><code>[16,9]</code></td>
      <td><code>H_12</code></td>
    </tr>
    <tr>
      <td><code>(C4 x C2) : C2</code></td>
      <td style="white-space:nowrap;"><code>[16,13]</code></td>
      <td><code>H_7</code>, <code>H_12</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">3</td>
      <td><code>SL(2,3)</code></td>
      <td style="white-space:nowrap;"><code>[24,3]</code></td>
      <td><code>H_14</code>, <code>H_15</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">4</td>
      <td><code>(C4 x C4) : C2</code></td>
      <td style="white-space:nowrap;"><code>[32,11]</code></td>
      <td><code>H_7</code></td>
    </tr>
  </tbody>
</table>

### `G_24` — $A_{3,3}$

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap; text-align:right;">Index <i>m</i></th>
      <th style="min-width:280px;">Candidate full group</th>
      <th style="width:125px; min-width:125px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:240px;">YYZ source(s)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">1</td>
      <td><code>(C3 x C3) : C2</code></td>
      <td style="white-space:nowrap;"><code>[18,4]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_4</code>, <code>H_7</code>, <code>H_10</code>, <code>H_11</code>, <code>H_15</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="3" style="white-space:nowrap; text-align:right; vertical-align:top;">2</td>
      <td><code>(C3 x C3) : C4</code></td>
      <td style="white-space:nowrap;"><code>[36,9]</code></td>
      <td><code>H_1</code>, <code>H_7</code>, <code>H_10</code>, <code>H_11</code>, <code>H_15</code></td>
    </tr>
    <tr>
      <td><code>S3 x S3</code></td>
      <td style="white-space:nowrap;"><code>[36,10]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_4</code>, <code>H_7</code>, <code>H_11</code></td>
    </tr>
    <tr>
      <td><code>C2 x ((C3 x C3) : C2)</code></td>
      <td style="white-space:nowrap;"><code>[36,13]</code></td>
      <td><code>H_1</code>, <code>H_4</code>, <code>H_7</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="2" style="white-space:nowrap; text-align:right; vertical-align:top;">3</td>
      <td><code>(C3 x C3) : C6</code></td>
      <td style="white-space:nowrap;"><code>[54,5]</code></td>
      <td><code>H_1</code>, <code>H_7</code>, <code>H_15</code></td>
    </tr>
    <tr>
      <td><code>C3 x ((C3 x C3) : C2)</code></td>
      <td style="white-space:nowrap;"><code>[54,13]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_4</code>, <code>H_7</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">4</td>
      <td><code>C2 x ((C3 x C3) : C4)</code></td>
      <td style="white-space:nowrap;"><code>[72,45]</code></td>
      <td><code>H_1</code>, <code>H_7</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="4" style="white-space:nowrap; text-align:right; vertical-align:top;">6</td>
      <td><code>C2 x ((C3 x C3) : C6)</code></td>
      <td style="white-space:nowrap;"><code>[108,25]</code></td>
      <td><code>H_1</code></td>
    </tr>
    <tr>
      <td><code>C3 x ((C3 x C3) : C4)</code></td>
      <td style="white-space:nowrap;"><code>[108,36]</code></td>
      <td><code>H_1</code>, <code>H_7</code></td>
    </tr>
    <tr>
      <td><code>C3 x S3 x S3</code></td>
      <td style="white-space:nowrap;"><code>[108,38]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_4</code>, <code>H_7</code></td>
    </tr>
    <tr>
      <td><code>C6 x ((C3 x C3) : C2)</code></td>
      <td style="white-space:nowrap;"><code>[108,43]</code></td>
      <td><code>H_1</code>, <code>H_4</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">12</td>
      <td><code>C6 x ((C3 x C3) : C4)</code></td>
      <td style="white-space:nowrap;"><code>[216,168]</code></td>
      <td><code>H_1</code></td>
    </tr>
  </tbody>
</table>

### `G_25` — $D_{12}$

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap; text-align:right;">Index <i>m</i></th>
      <th style="min-width:280px;">Candidate full group</th>
      <th style="width:125px; min-width:125px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:240px;">YYZ source(s)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">1</td>
      <td><code>D12</code></td>
      <td style="white-space:nowrap;"><code>[12,4]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_6</code>, <code>H_7</code>, <code>H_11</code>, <code>H_13</code>, <code>H_14</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="4" style="white-space:nowrap; text-align:right; vertical-align:top;">2</td>
      <td><code>C4 x S3</code></td>
      <td style="white-space:nowrap;"><code>[24,5]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_7</code>, <code>H_11</code></td>
    </tr>
    <tr>
      <td><code>D24</code></td>
      <td style="white-space:nowrap;"><code>[24,6]</code></td>
      <td><code>H_1</code>, <code>H_4</code>, <code>H_7</code>, <code>H_11</code></td>
    </tr>
    <tr>
      <td><code>(C6 x C2) : C2</code></td>
      <td style="white-space:nowrap;"><code>[24,8]</code></td>
      <td><code>H_1</code>, <code>H_4</code>, <code>H_7</code>, <code>H_11</code></td>
    </tr>
    <tr>
      <td><code>C2 x C2 x S3</code></td>
      <td style="white-space:nowrap;"><code>[24,14]</code></td>
      <td><code>H_1</code>, <code>H_4</code>, <code>H_11</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">3</td>
      <td><code>C6 x S3</code></td>
      <td style="white-space:nowrap;"><code>[36,12]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_6</code>, <code>H_7</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">4</td>
      <td><code>C8 x S3</code></td>
      <td style="white-space:nowrap;"><code>[48,4]</code></td>
      <td><code>H_3</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="4" style="white-space:nowrap; text-align:right; vertical-align:top;">6</td>
      <td><code>C12 x S3</code></td>
      <td style="white-space:nowrap;"><code>[72,27]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_7</code></td>
    </tr>
    <tr>
      <td><code>C3 x D24</code></td>
      <td style="white-space:nowrap;"><code>[72,28]</code></td>
      <td><code>H_1</code>, <code>H_4</code></td>
    </tr>
    <tr>
      <td><code>C3 x ((C6 x C2) : C2)</code></td>
      <td style="white-space:nowrap;"><code>[72,30]</code></td>
      <td><code>H_1</code>, <code>H_4</code></td>
    </tr>
    <tr>
      <td><code>C2 x C6 x S3</code></td>
      <td style="white-space:nowrap;"><code>[72,48]</code></td>
      <td><code>H_1</code>, <code>H_4</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">12</td>
      <td><code>C24 x S3</code></td>
      <td style="white-space:nowrap;"><code>[144,69]</code></td>
      <td><code>H_3</code></td>
    </tr>
  </tbody>
</table>

### `G_26` — $A_4$

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap; text-align:right;">Index <i>m</i></th>
      <th style="min-width:280px;">Candidate full group</th>
      <th style="width:125px; min-width:125px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:240px;">YYZ source(s)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">1</td>
      <td><code>A4</code></td>
      <td style="white-space:nowrap;"><code>[12,3]</code></td>
      <td><code>H_1</code>, <code>H_4</code>, <code>H_6</code>, <code>H_10</code>, <code>H_11</code>, <code>H_13</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="2" style="white-space:nowrap; text-align:right; vertical-align:top;">2</td>
      <td><code>S4</code></td>
      <td style="white-space:nowrap;"><code>[24,12]</code></td>
      <td><code>H_1</code>, <code>H_4</code>, <code>H_10</code>, <code>H_11</code>, <code>H_13</code></td>
    </tr>
    <tr>
      <td><code>C2 x A4</code></td>
      <td style="white-space:nowrap;"><code>[24,13]</code></td>
      <td><code>H_1</code>, <code>H_4</code>, <code>H_11</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">3</td>
      <td><code>C3 x A4</code></td>
      <td style="white-space:nowrap;"><code>[36,11]</code></td>
      <td><code>H_1</code>, <code>H_4</code>, <code>H_6</code>, <code>H_11</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="2" style="white-space:nowrap; text-align:right; vertical-align:top;">6</td>
      <td><code>C3 x S4</code></td>
      <td style="white-space:nowrap;"><code>[72,42]</code></td>
      <td><code>H_1</code>, <code>H_4</code>, <code>H_11</code></td>
    </tr>
    <tr>
      <td><code>C6 x A4</code></td>
      <td style="white-space:nowrap;"><code>[72,47]</code></td>
      <td><code>H_1</code>, <code>H_4</code></td>
    </tr>
  </tbody>
</table>

### `G_27` — $D_{10}$

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap; text-align:right;">Index <i>m</i></th>
      <th style="min-width:280px;">Candidate full group</th>
      <th style="width:125px; min-width:125px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:240px;">YYZ source(s)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">1</td>
      <td><code>D10</code></td>
      <td style="white-space:nowrap;"><code>[10,1]</code></td>
      <td><code>H_1</code>, <code>H_4</code>, <code>H_6</code>, <code>H_10</code>, <code>H_11</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="2" style="white-space:nowrap; text-align:right; vertical-align:top;">2</td>
      <td><code>C5 : C4</code></td>
      <td style="white-space:nowrap;"><code>[20,3]</code></td>
      <td><code>H_1</code>, <code>H_4</code>, <code>H_10</code>, <code>H_11</code></td>
    </tr>
    <tr>
      <td><code>D20</code></td>
      <td style="white-space:nowrap;"><code>[20,4]</code></td>
      <td><code>H_4</code>, <code>H_11</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">3</td>
      <td><code>C3 x D10</code></td>
      <td style="white-space:nowrap;"><code>[30,2]</code></td>
      <td><code>H_1</code>, <code>H_4</code>, <code>H_6</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">4</td>
      <td><code>C2 x (C5 : C4)</code></td>
      <td style="white-space:nowrap;"><code>[40,12]</code></td>
      <td><code>H_4</code>, <code>H_11</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="2" style="white-space:nowrap; text-align:right; vertical-align:top;">6</td>
      <td><code>C3 x (C5 : C4)</code></td>
      <td style="white-space:nowrap;"><code>[60,6]</code></td>
      <td><code>H_1</code>, <code>H_4</code></td>
    </tr>
    <tr>
      <td><code>C6 x D10</code></td>
      <td style="white-space:nowrap;"><code>[60,10]</code></td>
      <td><code>H_4</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">12</td>
      <td><code>C6 x (C5 : C4)</code></td>
      <td style="white-space:nowrap;"><code>[120,40]</code></td>
      <td><code>H_4</code></td>
    </tr>
  </tbody>
</table>

### `G_28` — $D_8$

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap; text-align:right;">Index <i>m</i></th>
      <th style="min-width:280px;">Candidate full group</th>
      <th style="width:125px; min-width:125px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:240px;">YYZ source(s)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">1</td>
      <td><code>D8</code></td>
      <td style="white-space:nowrap;"><code>[8,3]</code></td>
      <td><code>H_1</code>, <code>H_4</code>, <code>H_7</code>, <code>H_10</code>, <code>H_11</code>, <code>H_12</code>, <code>H_13</code>, <code>H_14</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="4" style="white-space:nowrap; text-align:right; vertical-align:top;">2</td>
      <td><code>D16</code></td>
      <td style="white-space:nowrap;"><code>[16,7]</code></td>
      <td><code>H_12</code>, <code>H_13</code></td>
    </tr>
    <tr>
      <td><code>QD16</code></td>
      <td style="white-space:nowrap;"><code>[16,8]</code></td>
      <td><code>H_10</code>, <code>H_12</code>, <code>H_14</code></td>
    </tr>
    <tr>
      <td><code>C2 x D8</code></td>
      <td style="white-space:nowrap;"><code>[16,11]</code></td>
      <td><code>H_1</code>, <code>H_4</code>, <code>H_11</code></td>
    </tr>
    <tr>
      <td><code>(C4 x C2) : C2</code></td>
      <td style="white-space:nowrap;"><code>[16,13]</code></td>
      <td><code>H_7</code>, <code>H_12</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">3</td>
      <td><code>C3 x D8</code></td>
      <td style="white-space:nowrap;"><code>[24,10]</code></td>
      <td><code>H_1</code>, <code>H_4</code>, <code>H_11</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">4</td>
      <td><code>(C4 x C4) : C2</code></td>
      <td style="white-space:nowrap;"><code>[32,11]</code></td>
      <td><code>H_7</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">6</td>
      <td><code>C6 x D8</code></td>
      <td style="white-space:nowrap;"><code>[48,45]</code></td>
      <td><code>H_1</code>, <code>H_4</code></td>
    </tr>
  </tbody>
</table>

### `G_29` — Laza–Zheng: $C_4$

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap; text-align:right;">Index <i>m</i></th>
      <th style="min-width:280px;">Candidate full group</th>
      <th style="width:125px; min-width:125px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:240px;">YYZ source(s)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">1</td>
      <td><code>C4</code></td>
      <td style="white-space:nowrap;"><code>[4,1]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_5</code>, <code>H_7</code>, <code>H_8</code>, <code>H_10</code>, <code>H_11</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="4" style="white-space:nowrap; text-align:right; vertical-align:top;">2</td>
      <td><code>C8</code></td>
      <td style="white-space:nowrap;"><code>[8,1]</code></td>
      <td><code>H_3</code>, <code>H_5</code>, <code>H_7</code>, <code>H_8</code>, <code>H_10</code>, <code>H_12</code>, <code>H_13</code>, <code>H_14</code></td>
    </tr>
    <tr>
      <td><code>C4 x C2</code></td>
      <td style="white-space:nowrap;"><code>[8,2]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_7</code>, <code>H_11</code>, <code>H_12</code></td>
    </tr>
    <tr>
      <td><code>D8</code></td>
      <td style="white-space:nowrap;"><code>[8,3]</code></td>
      <td><code>H_1</code>, <code>H_4</code>, <code>H_7</code>, <code>H_10</code>, <code>H_11</code>, <code>H_12</code>, <code>H_13</code>, <code>H_14</code></td>
    </tr>
    <tr>
      <td><code>Q8</code></td>
      <td style="white-space:nowrap;"><code>[8,4]</code></td>
      <td><code>H_7</code>, <code>H_10</code>, <code>H_12</code>, <code>H_14</code>, <code>H_15</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">3</td>
      <td><code>C12</code></td>
      <td style="white-space:nowrap;"><code>[12,2]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_5</code>, <code>H_7</code>, <code>H_11</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="4" style="white-space:nowrap; text-align:right; vertical-align:top;">4</td>
      <td><code>C16</code></td>
      <td style="white-space:nowrap;"><code>[16,1]</code></td>
      <td><code>H_5</code>, <code>H_8</code></td>
    </tr>
    <tr>
      <td><code>C4 x C4</code></td>
      <td style="white-space:nowrap;"><code>[16,2]</code></td>
      <td><code>H_7</code></td>
    </tr>
    <tr>
      <td><code>C8 x C2</code></td>
      <td style="white-space:nowrap;"><code>[16,5]</code></td>
      <td><code>H_3</code>, <code>H_12</code></td>
    </tr>
    <tr>
      <td><code>C8 : C2</code></td>
      <td style="white-space:nowrap;"><code>[16,6]</code></td>
      <td><code>H_7</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="3" style="white-space:nowrap; text-align:right; vertical-align:top;">6</td>
      <td><code>C24</code></td>
      <td style="white-space:nowrap;"><code>[24,2]</code></td>
      <td><code>H_3</code>, <code>H_5</code></td>
    </tr>
    <tr>
      <td><code>C12 x C2</code></td>
      <td style="white-space:nowrap;"><code>[24,9]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_7</code></td>
    </tr>
    <tr>
      <td><code>C3 x D8</code></td>
      <td style="white-space:nowrap;"><code>[24,10]</code></td>
      <td><code>H_1</code>, <code>H_4</code>, <code>H_11</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">8</td>
      <td><code>C32</code></td>
      <td style="white-space:nowrap;"><code>[32,1]</code></td>
      <td><code>H_8</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="3" style="white-space:nowrap; text-align:right; vertical-align:top;">12</td>
      <td><code>C48</code></td>
      <td style="white-space:nowrap;"><code>[48,2]</code></td>
      <td><code>H_5</code></td>
    </tr>
    <tr>
      <td><code>C12 x C4</code></td>
      <td style="white-space:nowrap;"><code>[48,20]</code></td>
      <td><code>H_7</code></td>
    </tr>
    <tr>
      <td><code>C24 x C2</code></td>
      <td style="white-space:nowrap;"><code>[48,23]</code></td>
      <td><code>H_3</code></td>
    </tr>
  </tbody>
</table>

### `G_30` — Laza–Zheng: $S_3$

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap; text-align:right;">Index <i>m</i></th>
      <th style="min-width:280px;">Candidate full group</th>
      <th style="width:125px; min-width:125px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:240px;">YYZ source(s)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">1</td>
      <td><code>S3</code></td>
      <td style="white-space:nowrap;"><code>[6,1]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_6</code>, <code>H_7</code>, <code>H_10</code>, <code>H_11</code>, <code>H_13</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">2</td>
      <td><code>D12</code></td>
      <td style="white-space:nowrap;"><code>[12,4]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_6</code>, <code>H_7</code>, <code>H_11</code>, <code>H_13</code>, <code>H_14</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">3</td>
      <td><code>C3 x S3</code></td>
      <td style="white-space:nowrap;"><code>[18,3]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_6</code>, <code>H_7</code>, <code>H_11</code>, <code>H_15</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">4</td>
      <td><code>C4 x S3</code></td>
      <td style="white-space:nowrap;"><code>[24,5]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_7</code>, <code>H_11</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">6</td>
      <td><code>C6 x S3</code></td>
      <td style="white-space:nowrap;"><code>[36,12]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_6</code>, <code>H_7</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">8</td>
      <td><code>C8 x S3</code></td>
      <td style="white-space:nowrap;"><code>[48,4]</code></td>
      <td><code>H_3</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">12</td>
      <td><code>C12 x S3</code></td>
      <td style="white-space:nowrap;"><code>[72,27]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_7</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">24</td>
      <td><code>C24 x S3</code></td>
      <td style="white-space:nowrap;"><code>[144,69]</code></td>
      <td><code>H_3</code></td>
    </tr>
  </tbody>
</table>

### `G_31` — Laza–Zheng: $C_2^2$

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap; text-align:right;">Index <i>m</i></th>
      <th style="min-width:280px;">Candidate full group</th>
      <th style="width:125px; min-width:125px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:240px;">YYZ source(s)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">1</td>
      <td><code>C2 x C2</code></td>
      <td style="white-space:nowrap;"><code>[4,2]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_6</code>, <code>H_7</code>, <code>H_10</code>, <code>H_11</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="3" style="white-space:nowrap; text-align:right; vertical-align:top;">2</td>
      <td><code>C4 x C2</code></td>
      <td style="white-space:nowrap;"><code>[8,2]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_7</code>, <code>H_11</code>, <code>H_12</code></td>
    </tr>
    <tr>
      <td><code>D8</code></td>
      <td style="white-space:nowrap;"><code>[8,3]</code></td>
      <td><code>H_1</code>, <code>H_4</code>, <code>H_7</code>, <code>H_10</code>, <code>H_11</code>, <code>H_12</code>, <code>H_13</code>, <code>H_14</code></td>
    </tr>
    <tr>
      <td><code>C2 x C2 x C2</code></td>
      <td style="white-space:nowrap;"><code>[8,5]</code></td>
      <td><code>H_1</code>, <code>H_4</code>, <code>H_11</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="2" style="white-space:nowrap; text-align:right; vertical-align:top;">3</td>
      <td><code>A4</code></td>
      <td style="white-space:nowrap;"><code>[12,3]</code></td>
      <td><code>H_1</code>, <code>H_4</code>, <code>H_6</code>, <code>H_10</code>, <code>H_11</code>, <code>H_13</code></td>
    </tr>
    <tr>
      <td><code>C6 x C2</code></td>
      <td style="white-space:nowrap;"><code>[12,5]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_6</code>, <code>H_7</code>, <code>H_11</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="2" style="white-space:nowrap; text-align:right; vertical-align:top;">4</td>
      <td><code>C8 x C2</code></td>
      <td style="white-space:nowrap;"><code>[16,5]</code></td>
      <td><code>H_3</code>, <code>H_12</code></td>
    </tr>
    <tr>
      <td><code>C8 : C2</code></td>
      <td style="white-space:nowrap;"><code>[16,6]</code></td>
      <td><code>H_7</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="4" style="white-space:nowrap; text-align:right; vertical-align:top;">6</td>
      <td><code>C12 x C2</code></td>
      <td style="white-space:nowrap;"><code>[24,9]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_7</code></td>
    </tr>
    <tr>
      <td><code>C3 x D8</code></td>
      <td style="white-space:nowrap;"><code>[24,10]</code></td>
      <td><code>H_1</code>, <code>H_4</code>, <code>H_11</code></td>
    </tr>
    <tr>
      <td><code>C2 x A4</code></td>
      <td style="white-space:nowrap;"><code>[24,13]</code></td>
      <td><code>H_1</code>, <code>H_4</code>, <code>H_11</code></td>
    </tr>
    <tr>
      <td><code>C6 x C2 x C2</code></td>
      <td style="white-space:nowrap;"><code>[24,15]</code></td>
      <td><code>H_1</code>, <code>H_4</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">12</td>
      <td><code>C24 x C2</code></td>
      <td style="white-space:nowrap;"><code>[48,23]</code></td>
      <td><code>H_3</code></td>
    </tr>
  </tbody>
</table>

### `G_32` — Laza–Zheng: $C_3$

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap; text-align:right;">Index <i>m</i></th>
      <th style="min-width:280px;">Candidate full group</th>
      <th style="width:125px; min-width:125px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:240px;">YYZ source(s)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">1</td>
      <td><code>C3</code></td>
      <td style="white-space:nowrap;"><code>[3,1]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_5</code>, <code>H_6</code>, <code>H_7</code>, <code>H_9</code>, <code>H_10</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="2" style="white-space:nowrap; text-align:right; vertical-align:top;">2</td>
      <td><code>S3</code></td>
      <td style="white-space:nowrap;"><code>[6,1]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_6</code>, <code>H_7</code>, <code>H_10</code>, <code>H_11</code>, <code>H_13</code></td>
    </tr>
    <tr>
      <td><code>C6</code></td>
      <td style="white-space:nowrap;"><code>[6,2]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_5</code>, <code>H_6</code>, <code>H_7</code>, <code>H_9</code>, <code>H_11</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="2" style="white-space:nowrap; text-align:right; vertical-align:top;">3</td>
      <td><code>C9</code></td>
      <td style="white-space:nowrap;"><code>[9,1]</code></td>
      <td><code>H_1</code>, <code>H_2</code></td>
    </tr>
    <tr>
      <td><code>C3 x C3</code></td>
      <td style="white-space:nowrap;"><code>[9,2]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_6</code>, <code>H_7</code>, <code>H_9</code>, <code>H_10</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="2" style="white-space:nowrap; text-align:right; vertical-align:top;">4</td>
      <td><code>C3 : C4</code></td>
      <td style="white-space:nowrap;"><code>[12,1]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_7</code>, <code>H_11</code></td>
    </tr>
    <tr>
      <td><code>C12</code></td>
      <td style="white-space:nowrap;"><code>[12,2]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_5</code>, <code>H_7</code>, <code>H_11</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="3" style="white-space:nowrap; text-align:right; vertical-align:top;">6</td>
      <td><code>C18</code></td>
      <td style="white-space:nowrap;"><code>[18,2]</code></td>
      <td><code>H_1</code>, <code>H_2</code></td>
    </tr>
    <tr>
      <td><code>C3 x S3</code></td>
      <td style="white-space:nowrap;"><code>[18,3]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_6</code>, <code>H_7</code>, <code>H_11</code>, <code>H_15</code></td>
    </tr>
    <tr>
      <td><code>C6 x C3</code></td>
      <td style="white-space:nowrap;"><code>[18,5]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_6</code>, <code>H_7</code>, <code>H_9</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="2" style="white-space:nowrap; text-align:right; vertical-align:top;">8</td>
      <td><code>C3 : C8</code></td>
      <td style="white-space:nowrap;"><code>[24,1]</code></td>
      <td><code>H_3</code>, <code>H_7</code></td>
    </tr>
    <tr>
      <td><code>C24</code></td>
      <td style="white-space:nowrap;"><code>[24,2]</code></td>
      <td><code>H_3</code>, <code>H_5</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="3" style="white-space:nowrap; text-align:right; vertical-align:top;">12</td>
      <td><code>C36</code></td>
      <td style="white-space:nowrap;"><code>[36,2]</code></td>
      <td><code>H_2</code></td>
    </tr>
    <tr>
      <td><code>C3 x (C3 : C4)</code></td>
      <td style="white-space:nowrap;"><code>[36,6]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_7</code></td>
    </tr>
    <tr>
      <td><code>C12 x C3</code></td>
      <td style="white-space:nowrap;"><code>[36,8]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_7</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">16</td>
      <td><code>C48</code></td>
      <td style="white-space:nowrap;"><code>[48,2]</code></td>
      <td><code>H_5</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="2" style="white-space:nowrap; text-align:right; vertical-align:top;">24</td>
      <td><code>C3 x (C3 : C8)</code></td>
      <td style="white-space:nowrap;"><code>[72,12]</code></td>
      <td><code>H_3</code></td>
    </tr>
    <tr>
      <td><code>C24 x C3</code></td>
      <td style="white-space:nowrap;"><code>[72,14]</code></td>
      <td><code>H_3</code></td>
    </tr>
  </tbody>
</table>

### `G_33` — Laza–Zheng: $C_2$

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap; text-align:right;">Index <i>m</i></th>
      <th style="min-width:280px;">Candidate full group</th>
      <th style="width:125px; min-width:125px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:240px;">YYZ source(s)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">1</td>
      <td><code>C2</code></td>
      <td style="white-space:nowrap;"><code>[2,1]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_5</code>, <code>H_6</code>, <code>H_7</code>, <code>H_8</code>, <code>H_9</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="2" style="white-space:nowrap; text-align:right; vertical-align:top;">2</td>
      <td><code>C4</code></td>
      <td style="white-space:nowrap;"><code>[4,1]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_5</code>, <code>H_7</code>, <code>H_8</code>, <code>H_10</code>, <code>H_11</code></td>
    </tr>
    <tr>
      <td><code>C2 x C2</code></td>
      <td style="white-space:nowrap;"><code>[4,2]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_6</code>, <code>H_7</code>, <code>H_10</code>, <code>H_11</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">3</td>
      <td><code>C6</code></td>
      <td style="white-space:nowrap;"><code>[6,2]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_5</code>, <code>H_6</code>, <code>H_7</code>, <code>H_9</code>, <code>H_11</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="2" style="white-space:nowrap; text-align:right; vertical-align:top;">4</td>
      <td><code>C8</code></td>
      <td style="white-space:nowrap;"><code>[8,1]</code></td>
      <td><code>H_3</code>, <code>H_5</code>, <code>H_7</code>, <code>H_8</code>, <code>H_10</code>, <code>H_12</code>, <code>H_13</code>, <code>H_14</code></td>
    </tr>
    <tr>
      <td><code>C4 x C2</code></td>
      <td style="white-space:nowrap;"><code>[8,2]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_7</code>, <code>H_11</code>, <code>H_12</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="2" style="white-space:nowrap; text-align:right; vertical-align:top;">6</td>
      <td><code>C12</code></td>
      <td style="white-space:nowrap;"><code>[12,2]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_5</code>, <code>H_7</code>, <code>H_11</code></td>
    </tr>
    <tr>
      <td><code>C6 x C2</code></td>
      <td style="white-space:nowrap;"><code>[12,5]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_6</code>, <code>H_7</code>, <code>H_11</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="2" style="white-space:nowrap; text-align:right; vertical-align:top;">8</td>
      <td><code>C16</code></td>
      <td style="white-space:nowrap;"><code>[16,1]</code></td>
      <td><code>H_5</code>, <code>H_8</code></td>
    </tr>
    <tr>
      <td><code>C8 x C2</code></td>
      <td style="white-space:nowrap;"><code>[16,5]</code></td>
      <td><code>H_3</code>, <code>H_12</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="2" style="white-space:nowrap; text-align:right; vertical-align:top;">12</td>
      <td><code>C24</code></td>
      <td style="white-space:nowrap;"><code>[24,2]</code></td>
      <td><code>H_3</code>, <code>H_5</code></td>
    </tr>
    <tr>
      <td><code>C12 x C2</code></td>
      <td style="white-space:nowrap;"><code>[24,9]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_7</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">16</td>
      <td><code>C32</code></td>
      <td style="white-space:nowrap;"><code>[32,1]</code></td>
      <td><code>H_8</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td rowspan="2" style="white-space:nowrap; text-align:right; vertical-align:top;">24</td>
      <td><code>C48</code></td>
      <td style="white-space:nowrap;"><code>[48,2]</code></td>
      <td><code>H_5</code></td>
    </tr>
    <tr>
      <td><code>C24 x C2</code></td>
      <td style="white-space:nowrap;"><code>[48,23]</code></td>
      <td><code>H_3</code></td>
    </tr>
  </tbody>
</table>

### `G_34` — Laza–Zheng: $1$

<table style="width:100%; table-layout:auto;">
  <thead>
    <tr>
      <th style="width:70px; white-space:nowrap; text-align:right;">Index <i>m</i></th>
      <th style="min-width:280px;">Candidate full group</th>
      <th style="width:125px; min-width:125px; white-space:nowrap;">GAP ID</th>
      <th style="min-width:240px;">YYZ source(s)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">1</td>
      <td><code>1</code></td>
      <td style="white-space:nowrap;"><code>[1,1]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_5</code>, <code>H_6</code>, <code>H_7</code>, <code>H_8</code>, <code>H_9</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">2</td>
      <td><code>C2</code></td>
      <td style="white-space:nowrap;"><code>[2,1]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_5</code>, <code>H_6</code>, <code>H_7</code>, <code>H_8</code>, <code>H_9</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">3</td>
      <td><code>C3</code></td>
      <td style="white-space:nowrap;"><code>[3,1]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_5</code>, <code>H_6</code>, <code>H_7</code>, <code>H_9</code>, <code>H_10</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">4</td>
      <td><code>C4</code></td>
      <td style="white-space:nowrap;"><code>[4,1]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_5</code>, <code>H_7</code>, <code>H_8</code>, <code>H_10</code>, <code>H_11</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">6</td>
      <td><code>C6</code></td>
      <td style="white-space:nowrap;"><code>[6,2]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_5</code>, <code>H_6</code>, <code>H_7</code>, <code>H_9</code>, <code>H_11</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">8</td>
      <td><code>C8</code></td>
      <td style="white-space:nowrap;"><code>[8,1]</code></td>
      <td><code>H_3</code>, <code>H_5</code>, <code>H_7</code>, <code>H_8</code>, <code>H_10</code>, <code>H_12</code>, <code>H_13</code>, <code>H_14</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">12</td>
      <td><code>C12</code></td>
      <td style="white-space:nowrap;"><code>[12,2]</code></td>
      <td><code>H_1</code>, <code>H_2</code>, <code>H_3</code>, <code>H_4</code>, <code>H_5</code>, <code>H_7</code>, <code>H_11</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">16</td>
      <td><code>C16</code></td>
      <td style="white-space:nowrap;"><code>[16,1]</code></td>
      <td><code>H_5</code>, <code>H_8</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">24</td>
      <td><code>C24</code></td>
      <td style="white-space:nowrap;"><code>[24,2]</code></td>
      <td><code>H_3</code>, <code>H_5</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">32</td>
      <td><code>C32</code></td>
      <td style="white-space:nowrap;"><code>[32,1]</code></td>
      <td><code>H_8</code></td>
    </tr>
    <tr style="border-top:1px solid #d0d7de;">
      <td style="white-space:nowrap; text-align:right; vertical-align:top;">48</td>
      <td><code>C48</code></td>
      <td style="white-space:nowrap;"><code>[48,2]</code></td>
      <td><code>H_5</code></td>
    </tr>
  </tbody>
</table>

## Interpretation

These tables give the outer group-theoretic candidate list used in the subsequent representation and invariant-cubic calculations. A listed candidate has passed the YYZ subgroup test; this is only a necessary group-theoretic condition and does not by itself imply geometric realizability.
