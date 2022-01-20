## ------------------------------------------------------------------------------------------
# Define the variables

term <- 360 # 30 years in months
original_loan_amount <- 150000 # $150,000 loan
annual_rate <- 0.04 # 4% interest rate
monthly_rate <- annual_rate/12 # rate converted to monthly rate

# Formula to calculate monthly
# principal + interest payment

total_PI <- original_loan_amount *
   (monthly_rate * (1 + monthly_rate) ^ term)/
   (((1 + monthly_rate) ^ term) - 1)


## ------------------------------------------------------------------------------------------
# Initialize the vectors as numeric with a length equal
# to the term of the loan.

interest <- principal <- balance <- date <- vector("numeric", term)

loan_amount <- original_loan_amount
# For loop to calculate values for each payment

for (i in 1:term) {
   intr <- loan_amount * monthly_rate
   prnp <- total_PI - intr
   loan_amount <- loan_amount - prnp

   interest[i] <- intr
   principal[i] <- prnp
   balance[i] <- loan_amount
}

# Throw vectors into a table for easier use

library(tidyverse) # for data manipulation going forward

standard_schedule <- tibble(payment_number = 1:term,
                            interest,
                            principal,
                            balance)

# Print head of standard_schedule

library(knitr) # both libraries for printing tables
library(kableExtra)

standard_schedule %>%

  # Format columns to display as dollars

  modify_at(c("interest", "principal", "balance"), scales::dollar,
            largest_with_cents = 1e+6) %>%

  # Limit to first 10 payments

  head(10) %>%
  kable(booktabs = T) %>%
  kable_styling()


## ------------------------------------------------------------------------------------------
# Pivot longer makes it easier to visualize,
# but isn't totally necessary

standard_schedule %>%
  pivot_longer(cols = c("interest", "principal"),
               names_to = "Payment Portion",
               values_to = "amount") %>%
  ggplot(aes(payment_number, amount, color = `Payment Portion`)) +
  geom_line() +

  # '#85bb65' is the color of $$$

  scale_color_manual(values = c("red", "#85bb65")) +

  # Change the theme for better appearance

  theme_minimal() +
  scale_y_continuous(labels = scales::dollar) +
  labs(title = "Payment Portions of Monthly Mortgage")


## ------------------------------------------------------------------------------------------
# Filter for interest less than principal

standard_schedule %>%
  filter(interest < principal) %>%

  # Include only the first observation

  head(1) %>%

  #  Prettify for table

  modify_at(c("interest", "principal", "balance"), scales::dollar,
            largest_with_cents = 1e+6) %>%
  kable(booktabs = T) %>%
  kable_styling()


## ------------------------------------------------------------------------------------------
library(lubridate)

# Set first payment date

first_payment <- "2020-01-01"


# Add vector as variable to standard schedule

standard_schedule <- standard_schedule %>%
  mutate(date = seq(from = ymd(first_payment), by = "month",
            length.out = term)) %>%
  select(date, everything())

standard_schedule %>%
  modify_at(c("interest", "principal", "balance"), scales::dollar,
          largest_with_cents = 1e+6) %>%
  head(10) %>%
  kable(booktabs = T) %>%
  kable_styling()



## ------------------------------------------------------------------------------------------
standard_schedule %>%
  filter(interest < principal) %>%
  head(1) %>%
  modify_at(c("interest", "principal", "balance"), scales::dollar,
            largest_with_cents = 1e+6) %>%
  kable(booktabs = T) %>%
  kable_styling()


## ----message=FALSE, warning=FALSE----------------------------------------------------------
# Create new variables for updated schedule

loan_amount1 <- original_loan_amount

interest1 <- principal1 <- extra <- xtra <- balance1 <- bonus <- NULL

# Set the extra monthly payment amount

for (i in 1:term) {

  # Stop the for loop when blance is paid off
  # Otherwise, loop will keep making monthly payments
  # Also must be sure to round values to 0.00

  if(loan_amount1 > 0.00) {
    intr1 <- (loan_amount1 * monthly_rate) %>%

      # Round to 0.00 for payments

      round(2)

    # Last payment won't be in full

    prnp1 <- ifelse(loan_amount1 < (total_PI - intr1),
                    loan_amount1,
                    total_PI - intr1) %>% round(2)

    # Last payment won't need extra payment

    xtra <- ifelse(loan_amount1 < (total_PI - intr1), 0, 100)

    loan_amount1 <- (loan_amount1 - prnp1 - xtra) %>%
      round(2)

    extra[i] <- xtra
    interest1[i] <- intr1
    principal1[i] <- prnp1
    balance1[i] <- loan_amount1
  }
}

# Set new term length

new_term <- length(balance1)

# Combine in single table

updated_schedule <- tibble(date = seq(from = ymd(first_payment), by = "month",
                                      length.out = new_term),
                          payment_number = 1:new_term,
                          interest = interest1,
                          principal = principal1,
                          extra,
                          balance = balance1)




## ------------------------------------------------------------------------------------------

updated_schedule %>%
  modify_at(c("interest", "principal", "extra", "balance"), scales::dollar,
          largest_with_cents = 1e+6) %>%
  head(10) %>%
  kable(booktabs = T) %>%
  kable_styling()


## ------------------------------------------------------------------------------------------
updated_schedule %>%
  modify_at(c("interest", "principal", "extra", "balance"), scales::dollar,
          largest_with_cents = 1e+6) %>%
  tail(10) %>%
  kable(booktabs = T) %>%
  kable_styling()


## ------------------------------------------------------------------------------------------
# Viz is easier if schedules are joined
# First, create matching variables

ss <- standard_schedule %>%
  mutate(schedule = "standard",
         extra = 0)

us <- updated_schedule %>%
  mutate(schedule = "updated")

both_schedules <- bind_rows(ss, us)

both_schedules %>%
  group_by(schedule) %>%
  mutate(cum_int = cumsum(interest),
            cum_prnp = cumsum(principal)) %>%
  pivot_longer(cols = c("cum_int", "cum_prnp"),
               names_to = "Payment Portion",
               values_to = "amount") %>%
  filter(`Payment Portion` != "cum_prnp") %>%
  ggplot(aes(date, amount,
             group = schedule)) +
  geom_line(aes(linetype = schedule), color = "red") +

  # Change the theme for better appearance

  theme_minimal() +
  scale_y_continuous(labels = scales::dollar) +
  scale_linetype_discrete(labels = c("Standard Schedule", "Updated Schedule")) +
  labs(title = paste("Amount in Interest Saved: ", scales::dollar(sum(interest) - sum(interest1)), sep = ""),
       subtitle = paste("By Paying", scales::dollar(extra), "Extra Per Month", sep = " "),
       y = "Total Interest Paid",
       x = "Payment Date", linetype = "",
       caption = paste("Based on ", scales::dollar(original_loan_amount), " loan over ",
                       (term/12), " years.", sep = "")) +
  guides(linetype = guide_legend(override.aes = list(col = "red")))

