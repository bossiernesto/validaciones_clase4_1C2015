require 'rspec'

class ValidacionException < Exception
end

class Module

  def validate(sym, &block)
    metodo = sym.to_s
    alias_method "#{metodo}_old".to_sym, sym

    self.send(:define_method, sym) do |*args|
      unless self.instance_eval &block
        raise ValidacionException.new('Bleh')
      end

      self.send "#{metodo}_old".to_sym, *args
    end
  end

end

class A
  attr_accessor :valor_esperado, :valor_actual

  def initialize(esperado)
    self.valor_esperado= esperado
  end

  def sinparametros

  end

  validate :sinparametros do
    self.valor_actual == self.valor_esperado
  end
end


describe 'validaciones' do
  it 'deberia arrojar excepcion' do
    a = A.new(3)
    a.valor_esperado = 2

    expect { a.sinparametros }.to raise_error(ValidacionException)
  end
end


