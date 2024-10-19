library(tidyverse)

read_path <- "C:/Users/AYOMIDE/Desktop/T-material/coffee-db/"
save_path <- "C:/Users/AYOMIDE/Desktop/T-material/coffee-temp/"


# sales_reciepts --------------------------------------------------------------
sr <- read_csv(paste0(read_path, "sales_reciepts.csv"))


sr <- sr |> 
  rename(customer_transaction_id = transaction_id) |>
  arrange(transaction_date) |>
  mutate(transaction_id = row_number(), .before = 1) 

write_csv(sr, paste0(save_path, "sales_reciepts.csv"))


# product ---------------------------------------------------------------------
prod <- read_csv(paste0(read_path, "product.csv"))

View(prod)

prod |> sapply(\(x) sum(is.na(x)))

prod <- prod |>
  mutate(current_retail_price = str_replace_all(current_retail_price, "\\$", ""),
         current_retail_price = as.numeric(current_retail_price)) 

write_csv(prod, paste0(save_path, "product.csv"))

# Sales outlet ----------------------------------------------------------------
outlet <- read_csv(paste0(read_path, "sales_outlet.csv"))

outlet |> View()

outlet |> sapply(\(x) sum(is.na(x)))

write_csv(outlet, paste0(save_path, "sales_outlet.csv"))

# customers -------------------------------------------------------------------
customer <- read_csv(paste0(read_path, "customer.csv"))

customer |> View()

customer |> sapply(\(x) sum(is.na(x)))
customer <- customer |>
  rename(customer_name = `customer_first-name`)

write_csv(customer, paste0(save_path, "customer.csv"))

# Inventory -------------------------------------------------------------------
inventory <- read_csv(paste0(read_path, "pastry inventory.csv"))

inventory |>
  distinct(transaction_date) |>
  print(n = 30)

inventory <- inventory |>
  rename(percentage_waste = `% waste`) |>
  mutate(
    transaction_date = mdy(transaction_date),
    percentage_waste = str_remove_all(percentage_waste, "%")
  )

write_csv(inventory, paste0(save_path, "inventory.csv"))

# Staff -----------------------------------------------------------------------
staff <- read_csv(paste0(read_path, "staff.csv"))

staff <- staff |>
  select(-c(`...7`, `...8`)) |>
  mutate(start_date = mdy(start_date)) 

write_csv(staff, paste0(save_path, "staff.csv"))
