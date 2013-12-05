require 'pry'
require 'csv'

TAX_RATE = 0.30
class Employee
  attr_accessor :first_name, :last_name, :job, :salary, :commission, :bonuses, :quota

  def initalize(filename)
    @file = IO.read(filename)
    @file = CSV.parse("#{@file}")
  end
  
  def list_of_employees
    @employees_list = []
    CSV.foreach('employee_payroll.csv', headers: true) do |row|
      # read all information for each employee
      @first_name = filename["first_name"]
      @last_name = filename["last_name"]
      @job = filename["job"]
      @salary = filename["salary"].to_f
      @commission = filename.fetch["commission", 0]
      @bonuses = filename.fetch["bonuses", 0]
      @quota = filename.fetch["quota", 0]

      # pass the information into a hash for each employee
      @employee = { first_name: first_name, last_name: last_name, job: job, salary: salary, commission: commission, bonuses: bonuses, quota: quota }
      @employees_list << @employee
    end
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



    # CSV.foreach(@filename, headers:true) do |row|
    #   data = row.to_hash
    #   if data["employee_type"] == 'salary_only'
    #     @employees << Employee.new(data)
    #   elsif data["employee_type"] == 'quota'
    #     @employees << QuotaSalesPerson.new(data)
    #   elsif data["employee_type"] == 'commission'
    #     @employees << CommissionSalesPerson.new(data)
    #   elsif data["employee_type"] == 'owner'
    #     @employees << Owner.new(data)
    #   end



    # @employees = []
    # CSV.foreach('employee_payroll.csv', headers:true) do |row|


person = Employee.new('employee_payroll.csv')
worker = person.