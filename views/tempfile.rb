
def send_mail
#  Pony.mail(:to => 'and001@gmail.com',  :from => "#{@mail}", :subject => "Barbershop client message from #{@mail}", :body => "#{@usermessage}")
  Pony.mail (:name => 'Barbershop',
    :mail => @mail,
    :body => @usermessage,
    :to => 'and001@gmail.com',
    :subject => 'Barbershop client message from ' + @mail,
    :port => '587',
    :via => :smtp,
    :via_options => {
      :address              => 'smtp.gmail.com',
      :port                 => '587',
      :enable_starttls_auto => true,
      :user_name            => 'myster555',
      :password             => 'vapun1111',
      :authentication       => :plain,
      :domain               => 'localhost.localdomain'
    })
end
