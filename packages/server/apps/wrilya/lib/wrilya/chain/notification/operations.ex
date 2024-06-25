defmodule Wrilya.Chain.Notification.Operations do
  defmacro __using__(_opts) do
    quote do
      @unknown 0
      @game_pause 1
      @game_unpause 2
      @game_set_admin 3
      @game_set_gm 4
      @game_set_currency_proxy 5
      @game_set_item_proxy 6
      @game_set_entity_proxy 7
      @game_set_governor 8
      @game_set_vote_token 9
      @game_set_voidsman_create_cost 10
      @game_set_voidsman_upgrade_time_base 11
      @game_set_voidsman_upgrade_time_power 12
      @game_set_voidsman_upgrade_cost_base 13
      @game_set_voidsman_upgrade_cost_power 14
      @game_set_voidsman_max_stats 15
      @game_set_voidsman_max_competency 16
      @game_set_std_max_debit 17
      @game_set_collateral_debit_ratio 18
      @game_set_currency_unstake_time 19
      @currency_mint 20
      @currency_stake 21
      @currency_release 22
      @currency_claim 23
      @currency_payment 24
      @entity_create 25
      @entity_destroy 26
      @entity_transfer 27
      @entity_update 28
      @voidsman_train 29
      @voidsman_train_cancel 30
      @voidsman_certify 31
      @voidsman_set_training_requirement 32
    end
  end
end
