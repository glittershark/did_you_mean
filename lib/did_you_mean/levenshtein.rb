module DidYouMean
  module Levenshtein # :nodoc:
    # This code is based directly on the Text gem implementation
    # Returns a value representing the "cost" of transforming str1 into str2
    def distance(str1, str2)
      n = str1.length
      m = str2.length
      return m if n.zero?
      return n if m.zero?

      return 1 if str1.downcase == str2.downcase && str1 != str2

      d = (0..m).to_a
      x = nil

      str1.each_char.with_index(1) do |char1, i|
        str2.each_char.with_index do |char2, j|
          cost = (char1 == char2) ? 0 : 1
          x = min3(
            d[j+1] + 1, # insertion
            i + 1,      # deletion
            d[j] + cost # substitution
          )
          d[j] = i
          i = x
        end
        d[m] = x
      end

      x
    end
    module_function :distance

    private

    # detects the minimum value out of three arguments. This method is
    # faster than `[a, b, c].min` and puts less GC pressure.
    # See https://github.com/yuki24/did_you_mean/pull/1 for a performance
    # benchmark.
    def min3(a, b, c)
      if a < b && a < c
        a
      elsif b < c
        b
      else
        c
      end
    end
    module_function :min3
  end
end
