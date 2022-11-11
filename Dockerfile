FROM ruby:3.0.1
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
ENV BUNDLE_PATH /gems
RUN bundle install --jobs 4 --retry 5
COPY . /app
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
