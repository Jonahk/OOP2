require 'pry'
require 'csv'

class Employee

  TAX_RATE = 0.30

  attr_reader :first_name, :last_name, :job, :salary #:commission, :bonuses, :quota

  def initalize(information)
    @first_name = first_name
    @last_name = last_name
    @job = job
    @salary = salary
  end

  def gross_salary
    @salary.to_f / 12
  end

  def taxes
    gross_salary * TAX_RATE
  end

  def net_pay
    gross_salary - taxes
  end

  def self.load_csv(filename)
    employee_list = []
    CSV.foreach(filename, headers: true) do |row|
      employee_list << Employee.new(row['first_name'], row['last_name'], row['job'], row['salary'])
    end
    employee_list    
  end
end

# take the method out of the employee class and check the csv file to check what kind of employee they are and create their type of employee
class Sale
  attr_reader :last_name, :gross_sale_value

  def initialize(filename)
    @filename = filename
  end

  def total_sales
    sum = 0
    CSV.foreach(@filename, headers: true) do |row|
      sum += row[:gross_sale_value]
    end
    sum
  end
# store the gross sale value for each employee and how to pass the employee into the method
  def personal_sales(last_name)
    personal_sum = 0
    CSV.foreach(@filename, headers: true) do |row|
      if row[:last_name] == last_name
        personal_sum += row[:gross_sale_value]
      end
    end
    personal_sum
  end
end

class CommissionSalesPerson < Employee
    attr_reader  :commission
  def initialize(information)
    @commission = information["Commission"].to_f
    @gross_monthly_sales = information["gross_sale_value"].to_f
    super(information)
  end

  def commission_calc
    sum = 0
    if employee_payroll[:last_name] == sales[:last_name]
      sales.each do |money|
        money = sales[:gross_sale_value]
        sum += money
      end
    end
    sum
  end
  
  # read and parse sales.csv
  # iterate over sales.csv, check last name of commission jobs
  # if job == 'commision', get last_name and gross_sales_value for EACH employee
  # sum gross_sales_value PER employee
  # check gross_sales_value

  def gross_salary
    new_commission = @salary.to_f / 12 + @commission * @gross_monthly_sales
  end
end

employees = Employee.load_csv('employee_payroll.csv')
# same for sale