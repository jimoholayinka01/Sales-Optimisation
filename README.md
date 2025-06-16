# Sales-Optimisation
This repository contains an optimization model for minimizing supply chain costs in a multi-supplier, multi-product environment. The solution uses linear programming in R to determine the most cost-effective supplier allocation while meeting demand, lead time, and quality constraints.

# 1. Business Problem
A company manages a multi-supplier, multi-warehouse supply chain and wants to minimize total supply chain costs while ensuring:
✔ Demand fulfillment (all customer orders met)
✔ Supplier capacity constraints (orders ≤ production limits)
✔ Quality control (defect rates below threshold)
✔ Lead time compliance (delivery within acceptable time)
# Key Challenges
High procurement and shipping costs
Unpredictable supplier delays
Variable product defect rates
Need for cost-efficient inventory management
# Code Overview
i. Data Preparation:
Aggregate data by product and supplier.
Calculate average costs, lead times, and defect rates.
ii. Linear Programming Setup:
Define cost matrix (procurement + shipping).
Set demand constraints.
iii. Optimization:
Solve using lpSolve (minimize cost).
iv. Output:
Optimal order allocation.
Selected suppliers.
Total minimized cost.

# Recommendations 
1. Diversify Suppliers 
o Negotiate with Suppliers 1, 2, or 4 for better rates/terms to reduce 
dependency. 
o Use them as backups for high-risk products (e.g., skincare). 
2. Monitor Supplier Performance 
o Track lead times and defect rates for Suppliers 3 and 5 to avoid 
surprises. 
3. Re-Optimise Periodically 
o Adjust allocations if demand, costs, or supplier conditions change. 
4. Explore Bulk Discounts 
o Supplier 5 handles large volumes (34,342 units) which can be used to 
negotiate bulk discounts. 
