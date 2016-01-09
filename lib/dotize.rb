require "dotize/version"

module Dotize
  def dot(selector, &default_block)
    current_value = self

    begin
      keys_from_selector(selector).each do |key|
        raise StopIteration unless current_value.respond_to? :fetch
        current_value = current_value.fetch(key) { raise StopIteration }
      end
    rescue StopIteration
      return calc_default_value(default_block)
    end

    current_value
  end

  private

  def keys_from_selector(selector)
    selector.split('.')
  end

  def calc_default_value(default_block)
    default_block.call(self) unless default_block.nil?
  end
end
