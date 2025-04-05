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

	// UFUNCTION(BlueprintOverride)
	// void PreAttributeChange(FGameplayAttribute Attribute, float32& NewValue)
	// {
	// 	Debug::Print(f"Attribute Changing {Attribute.AttributeName}");
	// }
}