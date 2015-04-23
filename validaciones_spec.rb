require 'rspec'

class ValidacionException < Exception
end

class Module

  def validate(sym, &block)
    metodo = sym.to_s
    metodo_viejo = "#{metodo}_old".to_sym
    alias_method metodo_viejo, sym

    self.send(:define_method, sym) do |*args|

      unless self.instance_exec *args, &block
        raise ValidacionException.new('Bleh')
      end

      self.send metodo_viejo, *args
    end
  end

end

class A
  attr_accessor :valor_esperado

  def initialize(valor_esperado)
    self.valor_esperado= valor_esperado
  end

  def m(a)
    1
  end

  validate :m do |a|
    self.valor_esperado == a
  end
end


describe 'validaciones con parámetros' do
  it 'lanza excepcion con a.m(2), ya que 2 no es igual a 1' do
    a = A.new(1)
    expect { a.m(2) }.to raise_error(ValidacionException)
  end

  it 'no lanza exception' do
    a = A.new(1)
    expect(a.m(1)).to eq(1)
  end
end


