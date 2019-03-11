defmodule ZkPortalWeb.IssueLangView do

  def as_json(%ZkPortal.IssueLang{} = lang) do
    %{
      id: lang.id,
      is_published: lang.is_published,
      has_toc: lang.has_toc,
      pub_date: lang.pub_date,
      topic: lang.topic,
      editorial: lang.editorial,
      editorial_sig: lang.editorial_sig
    }
  end
  def as_json(_something_else) do
    nil
  end
end