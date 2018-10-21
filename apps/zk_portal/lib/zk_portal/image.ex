# mysql> desc Obrazki;
# +-----------+-------------+----+-----+------+----------------+
# |        Id |     int(11) | NO | PRI | NULL | auto_increment |
# |      Plik | varchar(30) | NO |     | NULL |                |
# | Szerokosc |     int(11) | NO |     | NULL |                |
# |  Wysokosc |     int(11) | NO |     | NULL |                |
# +-----------+-------------+----+-----+------+----------------+

defmodule ZkPortal.Image do
    use Ecto.Schema

    schema "images" do
        field :file, :string, null: false, size: 40
        field :width, :integer, null: false
        field :height, :integer, null: false
        belongs_to :banner, ZkPortal.Banner
        timestamps()
    end
end