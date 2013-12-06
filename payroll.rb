require 'pry'
require 'csv'

TAX_RATE = 0.30
class Employee
  attr_reader :first_name, :last_name, :job, :salary #:commission, :bonuses, :quota

  def initalize(information)
    @first_name = first_name
    @last_name = last_name
    @job = job
    @salary = salary
    # @file = IO.read('employee_payroll.csv')
    # @file = CSV.parse("#{@file}")
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

  # def self.load_csv(filename)
  
  # end

  def self.read_employee
    @employees_list = []
    CSV.foreach(@filename, headers:true) do |row|
      information = row.to_hash
      if information["job"] == 'Salary_Only'
        @employees_list << Employee.new(information)
      elsif information["job"] == 'Quota'
        @employees_list << QuotaSalesPerson.new(information)
      elsif information["job"] == 'Commission'
        @employees_list << CommissionSalesPerson.new(information)
      elsif information["job"] == 'Owner'
        @employees_list << Owner.new(information)
      end
    end
    @employees_list
  end
end


class Load
  def initialize(filename)
    @filename = filename
  end
  Employee.read_employee
end

#convert to sale object
class Sale
  def list_of_sales
    sales = []
    CSV.foreach('sales.csv', headers: true) do |row|
      sales << row
    end
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
  
  # set last names = to each other
  # if e
  #  get sales[:gross_sale_value]
  # sum up GSV
  # do math



  # read and parse sales.csv
  # iterate over sales.csv, check last name of commission jobs
  # if job == 'commision', get last_name and gross_sales_value for EACH employee
  # sum gross_sales_value PER employee
  # check gross_sales_value

  def gross_salary
    new_commission = @salary.to_f / 12 + @commission * @gross_monthly_sales
  end
end

# loads everything from csv file yay

# employees = Employee.load_csv('employee_payroll.csv')



# test = Employee.new
# binding.pry
# puts test

    # person = Employee.new('employee_payroll.csv')
    # worker = person.