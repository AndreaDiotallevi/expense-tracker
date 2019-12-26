feature "Log out" do
  scenario "a user can log out" do
    join
    click_button "Log Out"

    expect(page).to have_current_path "/"
    expect(page).to have_content "You have logged out"
  end
end
