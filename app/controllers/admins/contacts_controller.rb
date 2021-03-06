class Admins::ContactsController < ApplicationController
  before_action :authenticate_admin!
  def index
    @contacts = Contact.page(params[:page]).order(created_at: :desc).per(16)
    @users = User.all
  end

  def edit
    @contact = Contact.find(params[:id])
  end

  def update
    contact = Contact.find(params[:id]) # contact_mailer.rbの引数を指定
    contact.update(contact_params)
    user = contact.user
    ContactMailer.send_when_admin_reply(user, contact).deliver_now # 確認メールを送信
    redirect_to admins_contacts_path
  end

  def destroy
    contact = Contact.find(params[:id])
    contact.destroy
    redirect_to admins_contacts_path
  end

  private

  def contact_params
    params.require(:contact).permit(:title, :body, :reply)
  end
end
