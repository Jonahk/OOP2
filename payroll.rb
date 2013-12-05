require 'pry'
require 'csv'

TAX_RATE = 0.30
class Employee
  attr_accessor :first_name, :last_name, :job, :salary, :commission, :bonuses, :quota

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
end

class Load
  def initialize(filename)
    @filename = filename
  end

  def read_employee
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

class Sales
  def list_of_sales
    sales = []
    CSV.foreach('sales.csv', headers: true) do |row|
      sales << row
    end
  end
end



# test = Employee.new
# binding.pry
# puts test

    # person = Employee.new('employee_payroll.csv')
    # worker = person.