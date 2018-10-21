# mysql> desc Bannery;
# +-----------+---------------+-----+-----+------+----------------+
# |        Id |       int(11) |  NO | PRI | NULL | auto_increment |
# |  IsSilent |    tinyint(4) |  NO |     |    0 |                |
# | StartDate |          date | YES |     | NULL |                |
# |   EndDate |          date | YES |     | NULL |                |
# |       Url | varchar(1024) | YES |     | NULL |                |
# |    Weight |   smallint(6) |  NO |     |   10 |                |
# | ObrazekId |       int(11) | YES |     | NULL |                |
# +-----------+---------------+-----+-----+------+----------------+

defmodule ZkPortal.Banner do
    use Ecto.Schema

    schema "banners" do
        field :is_silent, :boolean, null: false, default: false
        field :start_date, :date
        field :end_date, :date
        field :url, :string, size: 1024
        field :weight, :integer, null: false, default: 10
        has_one :image, ZkPortal.Image
        timestamps()
    end
end