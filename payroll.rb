require 'csv'

class Employee

  TAX_RATE = 0.30

  attr_reader :first_name, :last_name, :job, :salary

  def initialize(information, sales)

    @first_name = information["first_name"]
    @last_name = information["last_name"]
    @job = information["job"]
    @salary = information["salary"].to_f
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
  def self.load_csv(filename, sales_filename)
    sales = TotalSales.new(sales_filename)

    employee_list = []
    CSV.foreach(filename, headers: true) do |row|
      data = row.to_hash
      if data["job"] == 'Salary_Only'
        employee_list << Employee.new(data, sales)
      elsif data["job"] == 'Quota'
        employee_list << QuotaSalesPerson.new(data, sales)
      elsif data["job"] == 'Commission'
        employee_list << CommissionSalesPerson.new(data, sales)
      elsif data["job"] == 'Owner'
        employee_list << Owner.new(data, sales)
      end
    end
    employee_list    
  end  
end

class TotalSales

  def initialize(filename)
    @sales = Hash.new(0)

    CSV.foreach(filename, headers: true) do |row|
      last_name = row["last_name"]
      gross_sale_value = row["gross_sale_value"] 
      @sales[last_name] += gross_sale_value.to_f
    end
  end

  def total_sales
    sum = 0
    @sales.each do |lastname, amount|
      sum += amount
    end
    sum    
  end

  def personal_sales(last_name)
    @sales[last_name]
  end
end

class CommissionSalesPerson < Employee
  attr_reader :commission

  def initialize(information, sales)
    super(information, sales)
    @commission = information["commission"].to_f
    @personal_sales = sales.personal_sales(@last_name)
  end

  def commission
    @personal_sales * @commission
  end

  def gross_salary
    @salary.to_f / 12 + commission
  end  
end

class QuotaSalesPerson < Employee
  attr_reader :bonuses, :quota

  def initialize(information, sales)
    super(information, sales)

    @bonuses = information["bonuses"].to_f
    @quota = information["quota"].to_f
    @personal_sales = sales.personal_sales(@last_name)
    
  end

  def bonus
    if @personal_sales >= @quota
      @bonuses
    else
      0
    end
  end

  def gross_salary
    @salary.to_f / 12 + bonus
  end  
end

class Owner < Employee
  attr_reader :bonuses, :quota

  def initialize(information, sales)
    super(information, sales)

    @total_sales = sales.total_sales
    @bonuses = information["bonuses"].to_f
    @quota = information["quota"].to_f
  end

  def bonus
    if @total_sales >= @quota
      @bonuses
    else
      0
    end
  end

  def gross_salary
    @salary.to_f / 12 + bonus
  end  
end



employees = Load.load_csv('employee_payroll.csv', 'sales.csv')

employees.each do |employee|
  puts "***#{employee.first_name} #{employee.last_name}***"
  
  printf "Gross Salary: $%.2f\n", employee.gross_salary
  if employee.job == 'Commission'
    printf "Commission: $%.2f\n", employee.commission
  elsif employee.job == 'Quota'
    printf "Bonus: $%.2f\n", employee.bonus
  elsif employee.job == 'Owner'
    printf "Bonus: $%.2f\n", employee.bonus
    # puts "Bonus: #{employee.bonus}" 
  end

  printf "Net Pay: $%.2f\n", employee.net_pay
end