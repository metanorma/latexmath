require 'byebug'
require 'json'
require 'htmlentities'
require 'ox'
require 'latexmath/version'
require 'latexmath/latexml_requirement'
require 'latexmath/aggregator'
require 'latexmath/converter'
require 'latexmath/symbol'
require 'latexmath/tokenizer'
require 'latexmath/xml/element'

module Latexmath
  MATRICES = [
    '\\matrix',
    '\\matrix*',
    '\\pmatrix',
    '\\pmatrix*',
    '\\bmatrix',
    '\\bmatrix*',
    '\\Bmatrix',
    '\\Bmatrix*',
    '\\vmatrix',
    '\\vmatrix*',
    '\\Vmatrix',
    '\\Vmatrix*',
    '\\array',
    '\\substack'
  ].freeze

  SPACES = ['\\,', '\\:', '\\;', '\\\\', '\\quad', '\\qquad'].freeze

  LIMITS = ['\\lim', '\\sup', '\\inf', '\\max', '\\min'].freeze
  COMMANDS = {
    # command: [params_count, mathml_equivalent, attributes]
    '_' => [2, 'msub', {}],
    '^' => [2, 'msup', {}],
    '_^' => [3, 'msubsup', {}],
    '\\frac' => [2, 'mfrac', {}],
    '\\sqrt' => [1, 'msqrt', {}],
    '\\root' => [2, 'mroot', {}],
    '\\binom' => [2, 'mfrac', { "linethickness": '0' }],
    '\\left' => [
      1,
      'mo',
      [%w[stretchy true], %w[fence true], %w[form prefix]]
    ],
    '\\right' => [
      1,
      'mo',
      [%w[stretchy true], %w[fence true], %w[form postfix]]
    ],
    '\\overline' => [1, 'mover', {}],
    '\\bar' => [1, 'mover', {}],
    '\\underline' => [1, 'munder', {}],
    '\\limits' => [3, 'munderover', {}]
  }

  SPACES.each do |space|
    COMMANDS[space] = [0, 'mspace', { "width": '0.167em' }]
  end

  MATRICES.each do |matrix|
    COMMANDS[matrix] = [1, 'mtable', {}]
  end

  LIMITS.each do |limit|
    COMMANDS[limit] = [1, 'munder', {}]
  end

  Requirements = {
    latexml: LatexmlRequirement.new
  }.freeze

  def self.parse(string)
    lxm_input = HTMLEntities.new.decode(string)

    # parse
    Equation.new(lxm_input)
  end

  class Error < StandardError; end
end
