# frozen_string_literal: true

RSpec.configure do |c|
  c.around do |example|
    Sequel::Model.db.transaction(rollback: :always, auto_savepoint: true) { example.run }
  end
end
