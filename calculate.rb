#!/usr/bin/ruby
begin
  require 'citrus/grammars'
rescue StandardError
  puts "Missing Citrus gem.\n Type gem install citrus"
end
begin
  Citrus.load 'expression'
rescue StandardError
  puts 'expression.citrus file is missing'
end

# Calculator class to perform operations
class Calculator
  def initialize(operand1, operand2)
    @operand1 = operand1
    @operand2 = operand2
  end

  def add
    @operand1 + @operand2
  end

  def multiply
    @operand1 * @operand2
  end
end

# To Simplify expression
class Expression
  def initialize(expresion)
    @expression = expresion.dup
  end

  def to_array
    @expression = @expression.gsub!(/\W/, ' ').split(' ')
  end

  def simplify
    @@stack = []
    @expression.reverse.each do |digit|
      if !digit.match(/[a-z]/)
        @@stack.push(digit)
      else
        operand1 = @@stack.pop
        operand2 = @@stack.pop
        @calculate = Calculator.new operand1.to_i, operand2.to_i
        if digit == 'add'
          @@stack.push(@calculate.add)
        elsif digit == 'multiply'
          @@stack.push(@calculate.multiply)
        else
          puts $error
        end
      end
    end
    @@stack.pop
  end
end

$error = "Calculate 1.0 \n
Syntax Error \n
Some sample Operations \n
number: Type number [0-9]\n
Addition: \"(add digit digit)\"\n
Multiplication:\"(multiply digit digit)\"\n
Nesting: \"(add (multiply digit digit) digit)\"\n
*note: Take care of spaces and brackets\n
Syntax: ruby calculate.rb \"<operation>\"
Example: ruby calculate.rb \"(add 3 4)\""

begin
  ARGV
  rescue
    puts $error
  end

#simplifying arguments
if ARGV
  for argument in ARGV
    if argument.to_i != 0
      puts argument
    else
     begin
       match = ExpressionCheck.parse(argument)
      rescue StandardError
        puts $error
      end
      if match == argument
        expression = Expression.new argument
        expression.to_array
        puts expression.simplify
      end
    end
  end
end
