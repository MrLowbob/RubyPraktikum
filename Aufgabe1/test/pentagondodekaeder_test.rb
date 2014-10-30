# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'pentagondodekaeder'

class PentagondodekaederTest < Test::Unit::TestCase

  DELTA = 0.0000001
  
  def test_regular_dodecahedron_surface
    assert_in_delta(18.3370149, regular_dodecahedron_surface(1.0), DELTA)
    assert_in_delta(114.6063436, regular_dodecahedron_surface(2.5), DELTA)
  end
  
  def test_regular_dodecahedron_surface_checks
    assert_raise(RuntimeError) {regular_dodecahedron_surface(0.0)}
    assert_raise(RuntimeError) {regular_dodecahedron_surface(-1.0)}
    assert_raise(RuntimeError) {regular_dodecahedron_surface("1.0")}
    assert_raise(RuntimeError) {regular_dodecahedron_surface(1)}
  end
end
