# frozen_string_literal: true

if defined?(Empty)
  raise LoadError, "already initialized constant Empty"
else
  Empty = Kind::Empty
end
