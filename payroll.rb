require 'pry'
require 'csv'

class Employee

  TAX_RATE = 0.30

  attr_reader :first_name, :last_name, :job, :salary #:commission, :bonuses, :quota

  def initialize(information)

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
  def self.load_csv(filename)
    employee_list = []
    CSV.foreach(filename, headers: true) do |row|
      data = row.to_hash
      if data["job"] == 'Salary_Only'
        employee_list << Employee.new(data)
      elsif data["job"] == 'Quota'
        employee_list << QuotaSalesPerson.new(data)
      elsif data["job"] == 'Commission'
        employee_list << CommissionSalesPerson.new(data)
      elsif data["job"] == 'Owner'
        employee_list << Owner.new(data)
      end
    end
    employee_list    
  end  
end

class TotalSales

  def initialize(filename)
    @sales = Hash.new(0)
    @filename = filename
    CSV.foreach(@filename, headers: true) do |row|
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

  def initialize(information)
    sales = TotalSales.new('sales.csv')
    @commission = information["commission"].to_f
    @gross_sale_value = sales["gross_sale_value"].to_f
    super(information)
  end

  def commission_calc
    if @last_name == last_name
      @commission_earned = @commission * @gross_sale_value
    end
    @commission_earned
  end

  def gross_salary
    @salary.to_f / 12 + @commission_earned
  end  
end

class QuotaSalesPerson < Employee
  attr_reader :bonuses, :quota

  def initialize(information)
    sales = TotalSales.new('sales.csv')
    @bonuses = information["bonuses"].to_f
    @quota = information["quota"].to_f
    @gross_sale_value = sales["gross_sale_value"].to_f
    super(information)
  end

  def bonus_calc
    if @last_name == last_name
      if @gross_sale_value >= @quota
        @bonuses_earned = @bonuses
      else
        @bonuses_earned = 0
      end
      @bonuses_earned
    end
  end

  def gross_salary
    @salary.to_f / 12 + @bonuses_earned
  end  
end

class Owner < Employee
  attr_reader :bonuses, :quota

  def initialize(information)
    sales = TotalSales.new('sales.csv')
    @bonuses = information["bonuses"].to_f
    @quota = information["quota"].to_f
    super(information)
  end

  def bonus_calc
    if sales.total_sales >= @quota
      @bonuses_earned = @bonuses
    else
      @bonuses_earned = 0
    end
    @bonuses_earned
  end

  def gross_salary
    @salary.to_f / 12 + @bonuses_earned
  end  
end



employee_load = Load.load_csv('employee_payroll.csv')
sales = TotalSales.new('sales.csv')
employee_list.each do |employee|
  puts "***#{@first_name} #{@last_name}***"
  puts "Gross Salary: #{gross_salary}"
  if data["job"] == 'Commission'
    puts "Commission: #{commission_earned}" 
  elsif data["job"] == 'Quota'
    puts "Bonus: #{bonuses_earned}" 
  elsif data["job"] == 'Owner'
    puts "Bonus: #{bonuses_earned}" 
  end
  puts "Net Pay: #{net_pay}"
end