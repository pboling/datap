# frozen_string_literal: true

# Create a list, from a supplied base list, with exactly the specified size
# Entropy reduction will result in more repetition from the base list, and will not use the entire base list
class ListEntropy < ListFiller
  MAXIMUM_ENTROPY = 10_000
  ENTROPY_FACTOR = 10

  attr_reader :max_entropy, :entropy_factor

  def initialize(list, size:, max_entropy: 10_000, entropy_factor: 10)
    @max_entropy = max_entropy # we *want* duplicates in the data.
    @entropy_factor = entropy_factor # The number of page views must be much larger than the number of total referrers / urls
    super do
      # list will be reduced to a size of <entropy>, and then inflated
      @entropy = too_much_entropy?(size) ? reduced_entropy : max_entropy
      # Reduce/Inflate the set to have a maximum amount of entropy
      reduce_or_inflate(@entropy)
    end
  end

  private

  def reduced_entropy
    reduced = @target_size
    reduced /= entropy_factor while too_much_entropy?(reduced)
    reduced
  end

  def too_much_entropy?(size)
    target_entropy = size / entropy_factor.to_f
    target_entropy > max_entropy
  end
end
