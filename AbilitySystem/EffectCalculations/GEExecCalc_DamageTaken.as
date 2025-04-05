struct FWarriorDamageCapture
{
	FGameplayEffectAttributeCaptureDefinition AttackPowerCaptureDefinition;
	FGameplayEffectAttributeCaptureDefinition DefensePowerCaptureDefinition;
	FGameplayEffectAttributeCaptureDefinition DamageTakenCaptureDefinition;

	FWarriorDamageCapture()
	{
		AttackPowerCaptureDefinition =
			UAngelscriptGameplayEffectUtils::CaptureGameplayAttribute(UWarriorAttributeSet.Get(), n"AttackPower", EGameplayEffectAttributeCaptureSource::Source, false);
		DefensePowerCaptureDefinition = UAngelscriptGameplayEffectUtils::CaptureGameplayAttribute(UWarriorAttributeSet.Get(), n"DefensePower", EGameplayEffectAttributeCaptureSource::Target, false);
		DamageTakenCaptureDefinition = UAngelscriptGameplayEffectUtils::CaptureGameplayAttribute(UWarriorAttributeSet.Get(), n"DamageTaken", EGameplayEffectAttributeCaptureSource::Target, false);
	}
}

namespace DamageCaptureCalc
{
	const FWarriorDamageCapture DamageCapture = FWarriorDamageCapture();
}

class UGEExecCalc_DamageTaken : UGameplayEffectExecutionCalculation
{
	default RelevantAttributesToCapture.Add(
		DamageCaptureCalc::DamageCapture.AttackPowerCaptureDefinition);

	default RelevantAttributesToCapture.Add(
		DamageCaptureCalc::DamageCapture.DefensePowerCaptureDefinition);

	default RelevantAttributesToCapture.Add(
		DamageCaptureCalc::DamageCapture.DamageTakenCaptureDefinition);

	UFUNCTION(BlueprintOverride)
	void Execute(FGameplayEffectCustomExecutionParameters ExecutionParams,
				 FGameplayEffectCustomExecutionOutput& OutExecutionOutput) const
	{

		FGameplayEffectSpec EffectSpec = ExecutionParams.OwningSpec;

		FGameplayEffectExecutionParameters EvaluateParameters;
		EvaluateParameters.SetCapturedSourceTagsFromSpec(EffectSpec);

		float32 SourceAttackPower = 0.f;
		// float& SourceAttackPowerRef = &SourceAttackPower;
		bool AttemptResultAP = ExecutionParams.AttemptCalculateCapturedAttributeMagnitude(
			DamageCaptureCalc::DamageCapture.AttackPowerCaptureDefinition, EvaluateParameters, SourceAttackPower);

		if (!AttemptResultAP)
		{
			CppDebug::Print(f"No Attack Power", FColor::Red);
		}

		float BaseDamage = 0.f;
		int32 UsedLightAttackComboCount = 0;
		int32 UsedHeavyAttackComboCount = 0;

		for (auto TagMagnitude : EffectSpec.SetByCallerTagMagnitudes)
		{
			// UCppDebug::Print(f"Checking tag: {TagMagnitude.Key}");

			CppDebug::Print(f"Checking tag: {TagMagnitude.Key}", FColor::Red);
			if (TagMagnitude.Key.MatchesTagExact(GameplayTags::Shared_SetByCaller_BaseDamage))
			{
				BaseDamage = TagMagnitude.Value;
			}

			if (TagMagnitude.Key.MatchesTagExact(GameplayTags::Player_SetByCaller_AttackType_Light))
			{
				UsedLightAttackComboCount = TagMagnitude.Value;
			}

			if (TagMagnitude.Key.MatchesTagExact(GameplayTags::Player_SetByCaller_AttackType_Heavy))
			{
				UsedHeavyAttackComboCount = TagMagnitude.Value;
			}
		}

		float32 TargetDefensePower = 0.f;
		bool bAttemptResult = ExecutionParams.AttemptCalculateCapturedAttributeMagnitude(DamageCaptureCalc::DamageCapture.DefensePowerCaptureDefinition, EvaluateParameters, TargetDefensePower);
		if (!bAttemptResult)
		{
			CppDebug::Print(f"No Defense Power", FColor::Red);
			TargetDefensePower = 1;
		}

		if (UsedLightAttackComboCount > 0)
		{
			BaseDamage *= (UsedLightAttackComboCount - 1) * 0.05 + 1.f;
		}

		if (UsedHeavyAttackComboCount > 0)
		{
			BaseDamage *= (UsedHeavyAttackComboCount - 1) * 0.15 + 1.f;
		}

		const float FinalDamageDone = BaseDamage * SourceAttackPower / TargetDefensePower;

		FGameplayModifierEvaluatedData ModEvaluatedData = UAngelscriptGameplayEffectUtils::MakeGameplayModifierEvaluationData(
			UAngelscriptAttributeSet::GetGameplayAttribute(UWarriorAttributeSet::StaticClass(), n"DamageTaken"),
			EGameplayModOp::Override,
			FinalDamageDone);

		CppDebug::Print(f"Executed: {FinalDamageDone}", FColor::Red);
		if (FinalDamageDone > 0)
		{
			OutExecutionOutput.AddOutputModifier(
				ModEvaluatedData);
		}
	}
}