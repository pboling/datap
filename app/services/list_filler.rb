# frozen_string_literal: true

class ListFiller
  attr_reader :list

  def initialize(list, size:, **_args)
    raise ArgumentError, 'size must be an Integer' unless size.is_a?(Integer)

    @target_size = size
    @list = list.dup
    yield if block_given?

    # Reduce/Inflate the set, duplicating members, to make it the right size
    reduce_or_inflate(@target_size)
  end

  private

  def current_size
    list.length
  end

  def reduce_or_inflate(by)
    reduction = by - current_size
    case reduction <=> 0
    when -1 # LT0, i.e. there is too much entropy
      reduce(-reduction)
    when 0 # EQ0
      # noop
    when 1 # GT0, i.e. there are not enough
      fill(by)
    else
      raise 'Unexpected Comparison'
    end
  end

  # NOTE: filling with duplicates reduces entropy, but
  #   a) scenario isn't expected at runtime
  #   b) fine for specs
  #   c) normally we will have more entropy than needed
  def fill(max)
    while (remaining = max - current_size).positive?
      list.concat(list.sample(remaining))
    end
  end

  def reduce(reduction)
    list.pop(reduction)
  end
end
