class UWarriorAttributeSet : UAngelscriptAttributeSet
{
	UPROPERTY(BlueprintReadWrite, Category = "Health")
	FAngelscriptGameplayAttributeData CurrentHealth;

	UPROPERTY(BlueprintReadWrite, Category = "Health")
	FAngelscriptGameplayAttributeData MaxHealth;

	UPROPERTY(BlueprintReadWrite, Category = "Rage")
	FAngelscriptGameplayAttributeData CurrentRage;

	UPROPERTY(BlueprintReadWrite, Category = "Rage")
	FAngelscriptGameplayAttributeData MaxRage;

	UPROPERTY(BlueprintReadWrite, Category = "Damage")
	FAngelscriptGameplayAttributeData AttackPower;

	UPROPERTY(BlueprintReadWrite, Category = "Damage")
	FAngelscriptGameplayAttributeData DefensePower;

	UPROPERTY(BlueprintReadWrite, Category = "Damage")
	FAngelscriptGameplayAttributeData DamageTaken;

	UWarriorAttributeSet()
	{
		CurrentHealth.Initialize(1.f);
		MaxHealth.Initialize(1.f);
		CurrentRage.Initialize(1.f);
		MaxRage.Initialize(1.f);
		AttackPower.Initialize(1.f);
		DefensePower.Initialize(1.f);
		DamageTaken.Initialize(0.f);
	}

	UFUNCTION(BlueprintOverride)
	void PostGameplayEffectExecute(FGameplayEffectSpec EffectSpec,
								   FGameplayModifierEvaluatedData& EvaluatedData,
								   UAngelscriptAbilitySystemComponent AbilitySystemComponent)
	{

		if (EvaluatedData.Attribute.AttributeName == UAngelscriptAttributeSet::GetGameplayAttribute(UWarriorAttributeSet, n"CurrentHealth").AttributeName)

		{

			const float NewCurrentHealth = Math::Clamp(CurrentHealth.CurrentValue, 0.f, MaxHealth.CurrentValue);

			CurrentHealth.SetCurrentValue(NewCurrentHealth);
		}

		if (EvaluatedData.Attribute.AttributeName == UAngelscriptAttributeSet::GetGameplayAttribute(UWarriorAttributeSet, n"CurrentRage").AttributeName)

		{

			const float NewCurrentRage = Math::Clamp(CurrentRage.CurrentValue, 0.f, MaxRage.CurrentValue);

			CurrentRage.SetCurrentValue(NewCurrentRage);
		}

		if (EvaluatedData.Attribute.AttributeName == UAngelscriptAttributeSet::GetGameplayAttribute(UWarriorAttributeSet, n"DamageTaken").AttributeName)

		{

			const float OldHealth = CurrentHealth.CurrentValue;

			const float DamageDone = DamageTaken.CurrentValue;

			const float NewCurrentHealth = Math::Clamp(OldHealth - DamageDone, 0.f, MaxHealth.CurrentValue);

			CurrentHealth.SetCurrentValue(NewCurrentHealth);

			Debug::Print(f"Old Health: {OldHealth}, Damage Done: {DamageDone}, NewCurrentHealth: {NewCurrentHealth}");

			// TODO::Notify the UI

			// TODO::Handle character death

			if (NewCurrentHealth == 0.f)

			{
			}
		}
	}
}