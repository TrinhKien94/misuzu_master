module KairansHelper
  def updateKairanDetail(kairan_id, shain)
    Kairanshosai.where(回覧コード: kairan_id).destroy_all
    arrShain = shain.split(',') if shain
    return if arrShain.nil?
    arrShain.each do |shainNo|
      Kairanshosai.create(回覧コード: kairan_id, 対象者: shainNo, 状態: 0)
      # Update kairan on timeline view
      shainToUpdate = Shainmaster.find shainNo
      shainCurrentKairanCount = shainToUpdate.nil? ? 0:shainToUpdate.回覧件数.to_i
      shainCurrentKairanCount += 1
      shainToUpdate.update(回覧件数: shainCurrentKairanCount)
    end
  end

  # delete all old kairan before 1 month
  def old_kairan_process
    kairans = Kairan.where('created_at < :end_date', end_date: 30.days.ago)
    kairans.each do |kairan|
      Kairanshosai.where(回覧コード: kairan.id).destroy_all
    end
    kairans.destroy_all
  end
end
