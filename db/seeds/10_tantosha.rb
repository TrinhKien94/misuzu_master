User.delete_all
User.reset_pk_sequence
Shainmaster.all.each do |sha|
    a = sha.社員番号
    User.create! 担当者コード: a,担当者名称:'古川　知史',パスワード: a,再パスワード: a,
      email: a+"@gmail.com", password: a, password_confirmation: a
end
