# Load required libraries
library(lpSolve)
library(dplyr)

# Load the dataset (replace with your actual file path)
data <- read.csv("supply_chain_data.csv")

# Preprocess data: Aggregate by product type and supplier
aggregated_data <- data %>%
  group_by(Product.type, Supplier.name) %>%
  summarise(
    Total.Demand = sum(Number.of.products.sold),
    Avg.Price = mean(Price),
    Avg.Lead.Time = mean(Lead.time),
    Avg.Defect.Rate = mean(Defect.rates),
    Avg.Shipping.Cost = mean(Shipping.costs),
    Production.Volume = mean(Production.volumes),
    .groups = 'drop'
  )

# Define parameters
products <- unique(aggregated_data$Product.type)
suppliers <- unique(aggregated_data$Supplier.name)
n_products <- length(products)
n_suppliers <- length(suppliers)

# Demand for each product (simplified as total sold)
demand <- aggregated_data %>%
  group_by(Product.type) %>%
  summarise(Demand = sum(Total.Demand)) %>%
  pull(Demand)

# Cost matrix (procurement + shipping)
cost_matrix <- matrix(Inf, nrow = n_products, ncol = n_suppliers)  # Default: Infinite cost (unavailable)
for (i in 1:n_products) {
  for (j in 1:n_suppliers) {
    supplier_data <- aggregated_data %>%
      filter(Product.type == products[i], Supplier.name == suppliers[j])
    if (nrow(supplier_data) > 0) {
      cost_matrix[i, j] <- supplier_data$Avg.Price + supplier_data$Avg.Shipping.Cost
    }
  }
}

# Constraints: Demand fulfillment (sum of orders >= demand)
constraints <- matrix(0, nrow = n_products, ncol = n_products * n_suppliers)
for (i in 1:n_products) {
  constraints[i, ((i-1)*n_suppliers + 1):(i*n_suppliers)] <- 1
}

# Solve the linear program
lp_result <- lp(
  direction = "min",
  objective.in = as.vector(t(cost_matrix)),  # Flatten cost matrix
  const.mat = constraints,
  const.dir = rep(">=", n_products),
  const.rhs = demand,
  all.int = TRUE  # Integer solution (whole units)
)

# Extract and print results
if (lp_result$status == 0) {
  cat("Optimization successful!\n")
  cat("Total minimized cost:", lp_result$objval, "\n\n")
  
  # Reshape solution into a readable matrix
  solution <- matrix(lp_result$solution, nrow = n_products, ncol = n_suppliers, byrow = TRUE)
  rownames(solution) <- products
  colnames(solution) <- suppliers
  
  cat("Optimal order allocation (units per supplier):\n")
  print(solution)
  
  cat("\nSupplier selection summary:\n")
  supplier_summary <- colSums(solution) > 0
  print(supplier_summary[supplier_summary])  # Only show selected suppliers
} else {
  cat("Optimization failed. Status code:", lp_result$status, "\n")
}