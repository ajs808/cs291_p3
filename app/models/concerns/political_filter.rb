module PoliticalFilter
  extend ActiveSupport::Concern

  POLITICAL_TERMS = [
    'trump', 'biden', 'harris', 'kamala', 'vance', 'walz',
    'vote', 'election', 'elect', 'president', 'candidate',
    'liberal', 'conservative', 'democrat', 'republican'
  ].freeze

  included do
    validate :no_election_influence
  end

  private

  def no_election_influence
    content = if respond_to?(:title)
                [title, body].compact.join(' ').downcase
              else
                body.to_s.downcase
              end

    political_terms_found = []

    POLITICAL_TERMS.each do |term|
      if content.match?(/\b#{term}\b/i)
        political_terms_found << term
      end
    end

    if political_terms_found.any?
      errors.add(:base, "Political content detected: #{political_terms_found.join(', ')}")
    end
  end
end 